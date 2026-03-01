-- Minimal smoke checks (run as authenticated role in CI using pgTAP or manual assertions)
-- 1) users cannot edit others' profiles
-- expect: 0 rows updated
update users_profile set display_name = 'hacked' where id <> auth.uid();

-- 2) users can only read their like rows
select * from likes where user_id = auth.uid();

-- 3) offer messages visible only for offer participants
select m.*
from messages m
join offers o on o.id = m.offer_id
where auth.uid() not in (o.sender_id, o.receiver_id);

-- 4) meetup zones coordinates are not publicly exposed via public_items view
select id, title, meetup_zone_label from public_items limit 5;
