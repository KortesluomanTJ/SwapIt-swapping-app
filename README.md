# SwapIt MVP (Flutter + Supabase)

SwapIt is a **swap-only marketplace** built from a single Flutter codebase for **iOS, Android, and Web**. No money transactions are supported. Offers and negotiation are bundle-first. Giveaways are opt-in and separate from the main feed.

## MVP Scope Delivered
- Flutter app scaffold with `go_router`, responsive shell nav (bottom nav mobile, rail on web/desktop), and feature modules.
- Auth gate UI with phone OTP verification stub requirement before marketplace actions.
- Session-based location service abstraction with verified/unverified fallback model.
- Pro entitlement architecture via an interface (`EntitlementService`) with mock + future RevenueCat/native adapters.
- Supabase SQL migration: schema, enums, constraints, indexes, PostGIS, swipe candidates function, RLS policies.
- Supabase Edge Functions stubs: push dispatcher, thumbnail placeholder, OTP provider abstraction.
- RLS smoke test SQL.
- Legal template drafts + release readiness checklists.

## Repository Structure
```
lib/
  app/
  core/
  features/
supabase/
  migrations/
  functions/
docs/legal/
```

## Product Rules Enforced by Architecture
1. **Swap-only:** no payment entities; fulfillment is meetup or optional coordination-only shipping.
2. **Like = bookmark only:** `likes` table exists but no notification trigger requirement.
3. **Offer is primary action:** `offers`, `offer_revisions`, and `offer_lines` support bundle negotiation.
4. **Session location integrity:** profiles store `last_*` session location fields and verification flag.
5. **Privacy:** public reads via `public_items`/`get_swipe_candidates` expose labels + rounded distance, not raw coordinates.
6. **Phone verification gate:** `phone_verified_at` stored and required in UX flow before protected actions.
7. **Giveaways separate:** `items.kind = giveaway` handled separately from swipe function.
8. **Pro gating:** `is_pro` + `feature_flags` + entitlement service abstraction.

## Supabase Setup
1. Create project and enable auth providers.
2. Run migrations in order:
   - `supabase/migrations/202603010001_init_swapit.sql`
   - `supabase/migrations/202603010002_rls_smoke_tests.sql`
3. Deploy edge function stubs:
   - `supabase/functions/push_dispatcher`
   - `supabase/functions/thumbnail_stub`
   - `supabase/functions/otp_provider_stub`

## Flutter Run
```bash
flutter pub get
flutter run -d chrome \
  --dart-define=SUPABASE_URL=... \
  --dart-define=SUPABASE_ANON_KEY=...
```

## Web Deployment Checklist
- Build static app: `flutter build web --release --dart-define=...`
- Host `build/web` on static hosting (Vercel/Netlify/Firebase Hosting/S3+CloudFront).
- Enforce HTTPS (required for browser geolocation APIs).
- Configure CSP headers (example baseline):
  - `default-src 'self';`
  - `connect-src 'self' https://*.supabase.co wss://*.supabase.co;`
  - `img-src 'self' data: blob: https://*.supabase.co;`
- Ensure SPA rewrite to `index.html` for deep links.

## App Store / Play Store Release Definition of Done
- [ ] Bundle IDs/package names finalised.
- [ ] App name, subtitle, marketing text, and keywords localized.
- [ ] Required screenshots prepared:
  - iPhone 6.7" and 6.5"
  - iPad 12.9"
  - Android phone + 7" tablet
  - Web promo screenshots
- [ ] Icons, splash, adaptive icons complete.
- [ ] Permission strings:
  - iOS Info.plist: `NSLocationWhenInUseUsageDescription`, `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription`
  - Android: fine/coarse location, camera/media permissions with in-app rationale.
- [ ] In-app account deletion implemented and policy linked.
- [ ] Report/block and meetup safety tips visible.
- [ ] Age rating and prohibited content policy completed.

## Account Deletion Policy (MVP)
In-app “Delete Account” must:
1. Delete `users_profile` row.
2. Delete or anonymize user-owned items.
3. Remove personally attributable message content where feasible or anonymize sender metadata.
4. Preserve minimal moderation/audit records per policy.

## Security & Abuse Checklist
- Rate limits (recommendation):
  - offers/day: 20 free, 100 pro
  - giveaway claims/day: 3 free, 15 pro
  - message flood control: 5 messages / 10 seconds / thread
- Geo spoofing heuristics:
  - flag impossible location jumps (e.g., >300km in <30min)
  - flag frequent location flips in one day
- Moderation:
  - reports pipeline + admin triage queue
  - block list hard-excludes discovery and chat
- Backups:
  - daily logical backups + PITR enabled in Supabase

## Accessibility & QA Minimums
- Touch targets >= 44x44 logical pixels.
- Text contrast meets WCAG AA for major surfaces.
- Keyboard traversal on web for major routes.
- Smoke tests:
  - Auth + OTP gate
  - Location permission granted/denied path
  - Listing creation with meetup zone
  - Swipe pass/like/offer
  - Offer counter/accept + chat realtime
  - Giveaway claim flow + no-show cooldown
  - Pro gates for extended radius/shipping toggle

## CI (optional starter)
Add workflow to run:
- `flutter analyze`
- `flutter test`
- `flutter build web --release`

## Future Pro Subscription Integration
All premium checks should call `EntitlementService`:
- `currentEntitlement(): bool`
- `refreshEntitlement()`

Pluggable adapters:
1. RevenueCat (recommended)
2. Native StoreKit + Google Play Billing

---
## Legal Templates (Not Legal Advice)
See:
- `docs/legal/privacy_policy_template.md`
- `docs/legal/terms_template.md`
