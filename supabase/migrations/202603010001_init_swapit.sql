create extension if not exists postgis;
create extension if not exists pgcrypto;

create type item_kind as enum ('swap', 'giveaway');
create type item_status as enum ('active', 'hidden', 'locked', 'swapped', 'removed');
create type offer_status as enum ('pending', 'countered', 'accepted', 'declined', 'cancelled', 'expired', 'completed');
create type fulfillment_type as enum ('meetup', 'shipping');
create type claim_status as enum ('requested', 'accepted', 'confirmed', 'completed', 'released', 'no_show');

create table if not exists users_profile (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  avatar_url text,
  phone_verified_at timestamptz,
  is_pro boolean not null default false,
  giveaways_opt_in boolean not null default false,
  home_country_code text,
  home_region text,
  home_city text,
  home_lat double precision,
  home_lng double precision,
  home_geohash text,
  home_updated_at timestamptz,
  last_country_code text,
  last_region text,
  last_city text,
  last_lat double precision,
  last_lng double precision,
  last_geohash text,
  last_location_verified boolean not null default true,
  last_updated_at timestamptz,
  default_radius_km int not null default 15,
  reputation_score int not null default 0,
  completed_swaps int not null default 0,
  no_shows int not null default 0,
  flags_count int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists items (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references users_profile(id) on delete cascade,
  kind item_kind not null default 'swap',
  title text not null,
  description text,
  category text not null,
  condition text not null,
  status item_status not null default 'active',
  shipping_allowed boolean not null default false,
  country_code text,
  region text,
  city text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists item_photos (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null references items(id) on delete cascade,
  storage_path text not null,
  sort_order int not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists meetup_zones (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null unique references items(id) on delete cascade,
  label text not null,
  city text,
  center geography(point, 4326) not null,
  radius_meters int not null check (radius_meters between 300 and 800),
  created_at timestamptz not null default now()
);

create table if not exists likes (
  user_id uuid not null references users_profile(id) on delete cascade,
  item_id uuid not null references items(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, item_id)
);

create table if not exists passes (
  user_id uuid not null references users_profile(id) on delete cascade,
  item_id uuid not null references items(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, item_id)
);

create table if not exists offers (
  id uuid primary key default gen_random_uuid(),
  anchor_item_id uuid not null references items(id),
  sender_id uuid not null references users_profile(id),
  receiver_id uuid not null references users_profile(id),
  status offer_status not null default 'pending',
  fulfillment fulfillment_type not null default 'meetup',
  shipping_state text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  check (sender_id <> receiver_id)
);

create table if not exists offer_revisions (
  id uuid primary key default gen_random_uuid(),
  offer_id uuid not null references offers(id) on delete cascade,
  revision_no int not null,
  created_by uuid not null references users_profile(id),
  note text,
  created_at timestamptz not null default now(),
  unique (offer_id, revision_no)
);

create table if not exists offer_lines (
  id uuid primary key default gen_random_uuid(),
  revision_id uuid not null references offer_revisions(id) on delete cascade,
  item_id uuid not null references items(id),
  line_type text not null check (line_type in ('offered', 'requested'))
);

create table if not exists messages (
  id uuid primary key default gen_random_uuid(),
  offer_id uuid not null references offers(id) on delete cascade,
  sender_id uuid not null references users_profile(id),
  body text not null,
  message_type text not null default 'text',
  created_at timestamptz not null default now()
);

create table if not exists giveaway_slots (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null references items(id) on delete cascade,
  starts_at timestamptz not null,
  ends_at timestamptz not null,
  capacity int not null default 1,
  created_at timestamptz not null default now()
);

create table if not exists giveaway_claims (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null references items(id) on delete cascade,
  slot_id uuid not null references giveaway_slots(id) on delete cascade,
  requester_id uuid not null references users_profile(id) on delete cascade,
  owner_id uuid not null references users_profile(id) on delete cascade,
  status claim_status not null default 'requested',
  confirmed_at timestamptz,
  cooldown_until timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists blocks (
  blocker_id uuid not null references users_profile(id) on delete cascade,
  blocked_id uuid not null references users_profile(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id)
);

create table if not exists reports (
  id uuid primary key default gen_random_uuid(),
  reporter_id uuid not null references users_profile(id) on delete cascade,
  target_user_id uuid references users_profile(id),
  target_item_id uuid references items(id),
  reason text not null,
  details text,
  created_at timestamptz not null default now()
);

create table if not exists feature_flags (
  key text primary key,
  value jsonb not null,
  updated_at timestamptz not null default now()
);

insert into feature_flags (key, value) values
('free_radius_default', '{"km": 15}'),
('free_radius_cap', '{"km": 30}'),
('daily_explore_tokens_free', '{"count": 2}'),
('offer_limits_by_reputation', '{"new_user": 10, "trusted": 40}'),
('giveaway_claim_limits_by_reputation', '{"new_user": 2, "trusted": 8}')
on conflict (key) do nothing;

create index if not exists idx_items_owner on items(owner_id);
create index if not exists idx_items_kind_status on items(kind, status);
create index if not exists idx_meetup_zone_center on meetup_zones using gist(center);
create index if not exists idx_offers_sender_receiver on offers(sender_id, receiver_id);
create index if not exists idx_messages_offer_created on messages(offer_id, created_at);
create index if not exists idx_claims_requester on giveaway_claims(requester_id);

create or replace view public_items as
select
  i.id,
  i.owner_id,
  i.kind,
  i.title,
  i.description,
  i.category,
  i.condition,
  i.status,
  i.shipping_allowed,
  i.country_code,
  i.region,
  i.city,
  z.label as meetup_zone_label,
  z.city as meetup_zone_city,
  i.created_at
from items i
join meetup_zones z on z.item_id = i.id;

create or replace function get_swipe_candidates(
  p_user_id uuid,
  p_radius_km int,
  p_category text default null,
  p_condition text default null,
  p_limit int default 40,
  p_pass_ttl_days int default 7
)
returns table (
  item_id uuid,
  title text,
  category text,
  condition text,
  meetup_zone_label text,
  city text,
  distance_km numeric,
  created_at timestamptz
)
language sql
security definer
as $$
with me as (
  select last_lat, last_lng, last_country_code from users_profile where id = p_user_id
), candidates as (
  select
    i.id as item_id,
    i.title,
    i.category,
    i.condition,
    z.label as meetup_zone_label,
    coalesce(z.city, i.city) as city,
    round((st_distance(z.center, st_setsrid(st_makepoint(me.last_lng, me.last_lat), 4326)::geography) / 1000.0)::numeric, 1) as distance_km,
    i.created_at,
    (case when i.country_code = me.last_country_code then 0 else 1 end) as country_penalty
  from items i
  join meetup_zones z on z.item_id = i.id
  cross join me
  where i.owner_id <> p_user_id
    and i.kind = 'swap'
    and i.status = 'active'
    and (p_category is null or i.category = p_category)
    and (p_condition is null or i.condition = p_condition)
    and st_dwithin(z.center, st_setsrid(st_makepoint(me.last_lng, me.last_lat), 4326)::geography, p_radius_km * 1000)
    and not exists (select 1 from likes l where l.user_id = p_user_id and l.item_id = i.id)
    and not exists (
      select 1 from passes p
      where p.user_id = p_user_id and p.item_id = i.id and p.created_at > now() - make_interval(days => p_pass_ttl_days)
    )
    and not exists (
      select 1 from blocks b where (b.blocker_id = p_user_id and b.blocked_id = i.owner_id) or (b.blocker_id = i.owner_id and b.blocked_id = p_user_id)
    )
)
select item_id, title, category, condition, meetup_zone_label, city, distance_km, created_at
from candidates
order by country_penalty asc, distance_km asc, created_at desc
limit p_limit;
$$;

alter table users_profile enable row level security;
alter table items enable row level security;
alter table meetup_zones enable row level security;
alter table likes enable row level security;
alter table passes enable row level security;
alter table offers enable row level security;
alter table offer_revisions enable row level security;
alter table offer_lines enable row level security;
alter table messages enable row level security;
alter table giveaway_claims enable row level security;
alter table giveaway_slots enable row level security;
alter table blocks enable row level security;
alter table reports enable row level security;

create policy "profiles_select_self_or_public_fields" on users_profile
for select using (true);

create policy "profiles_update_own" on users_profile
for all using (auth.uid() = id) with check (auth.uid() = id);

create policy "items_select_public" on items for select using (status <> 'removed');
create policy "items_write_own" on items for all using (auth.uid() = owner_id) with check (auth.uid() = owner_id);

create policy "meetup_zone_owner_full" on meetup_zones
for all using (exists (select 1 from items i where i.id = item_id and i.owner_id = auth.uid()))
with check (exists (select 1 from items i where i.id = item_id and i.owner_id = auth.uid()));

create policy "likes_own" on likes for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "passes_own" on passes for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "blocks_own" on blocks for all using (auth.uid() = blocker_id) with check (auth.uid() = blocker_id);
create policy "reports_own_or_admin" on reports for all using (auth.uid() = reporter_id) with check (auth.uid() = reporter_id);

create policy "offers_participants" on offers
for select using (auth.uid() in (sender_id, receiver_id));
create policy "offers_sender_insert" on offers
for insert with check (auth.uid() = sender_id);
create policy "offers_participants_update" on offers
for update using (auth.uid() in (sender_id, receiver_id));

create policy "offer_revisions_participants" on offer_revisions
for all using (exists (select 1 from offers o where o.id = offer_id and auth.uid() in (o.sender_id, o.receiver_id)))
with check (exists (select 1 from offers o where o.id = offer_id and auth.uid() in (o.sender_id, o.receiver_id)));

create policy "offer_lines_participants" on offer_lines
for all using (exists (
  select 1 from offer_revisions r join offers o on o.id = r.offer_id
  where r.id = revision_id and auth.uid() in (o.sender_id, o.receiver_id)
)) with check (exists (
  select 1 from offer_revisions r join offers o on o.id = r.offer_id
  where r.id = revision_id and auth.uid() in (o.sender_id, o.receiver_id)
));

create policy "messages_participants" on messages
for all using (exists (select 1 from offers o where o.id = offer_id and auth.uid() in (o.sender_id, o.receiver_id)))
with check (exists (select 1 from offers o where o.id = offer_id and auth.uid() in (o.sender_id, o.receiver_id)));

create policy "giveaway_claims_participants" on giveaway_claims
for all using (auth.uid() in (requester_id, owner_id)) with check (auth.uid() in (requester_id, owner_id));

create policy "giveaway_slots_owner" on giveaway_slots
for all using (exists (select 1 from items i where i.id = item_id and i.owner_id = auth.uid()))
with check (exists (select 1 from items i where i.id = item_id and i.owner_id = auth.uid()));
