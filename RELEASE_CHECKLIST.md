# SwapIt Release Checklist (iOS / Android / Web)

## Product & Compliance
- [ ] Swap-only disclaimers visible in onboarding and terms.
- [ ] Privacy policy + terms linked in app and store listings.
- [ ] Pro gates validated (radius, remote explore, shipping coordination).
- [ ] Giveaways opt-in toggle works and feed separation verified.

## iOS
- [ ] Bundle ID, signing, provisioning, App Store Connect records.
- [ ] `Info.plist` permission strings for location/camera/photos.
- [ ] App Tracking transparency assessment (if applicable).
- [ ] TestFlight smoke pass with real geolocation and uploads.

## Android
- [ ] Application ID, signing key, Play Console listing.
- [ ] Runtime permission rationale for location/camera/media.
- [ ] Internal testing track smoke pass.

## Web
- [ ] HTTPS enabled + CSP headers configured.
- [ ] SPA rewrites and deep link refresh verified.
- [ ] Browser geolocation fallback path verified.
- [ ] Static hosting deployment and cache invalidation plan.

## Backend
- [ ] Supabase migrations applied to production.
- [ ] RLS policy smoke tests executed.
- [ ] Realtime channels validated for offers/messages/claims.
- [ ] Edge functions deployed with secrets configured.

## Safety & Operations
- [ ] Block/report flow tested.
- [ ] No-show cooldown logic tested.
- [ ] Support contact and abuse escalation runbook documented.
- [ ] Backup + restore drill scheduled.
