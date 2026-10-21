# Service Register

A field-service app for a PCB / CBC machine servicing business: companies,
machines, service visits, spare parts, invoices, payments, reminders and
reports — on one phone, **fully usable offline**, with optional cloud backup
and sync through Supabase.

Built with Flutter (Android + iOS), Riverpod, go_router, Drift (SQLite),
Supabase (Postgres + Auth + Storage) and `pdf`/`printing`.

---

## Quick start

```bash
flutter --version            # tested with Flutter 3.41.6 / Dart 3.11.4
flutter pub get
dart run build_runner build  # Drift code generation (already committed output is regenerated)
flutter run                  # local-only mode: no account, data stays on the phone
```

With cloud backup (see [supabase/README.md](supabase/README.md)):

```bash
cp env/example.json env/dev.json   # fill in SUPABASE_URL and SUPABASE_ANON_KEY
flutter run --dart-define-from-file=env/dev.json
```

`env/*.json` (except the example) is git-ignored. Only the public anon key goes
in the app; **never** the service-role key.

## Tests & checks

```bash
dart format lib test integration_test
dart analyze                               # → No issues found
flutter test                               # unit + repository + sync + widget tests
supabase/tests/run_schema_tests.sh         # SQL/RLS tests on a local PostgreSQL
flutter test integration_test -d <device>  # on-device end-to-end flow
```

| Acceptance criterion | Covered by |
|---|---|
| 1. Company create / edit / search / archive | `test/data/business_flow_test.dart` (Companies), `test/widget/app_flow_test.dart` |
| 2. Multiple machines per company | business_flow_test › *multiple machines belong to one company* |
| 3. Visit recorded against correct machine | *visit is recorded against the correct machine…*, *machine must belong to the selected company* |
| 4. Multiple spare parts per visit | same test (2 parts, totals) |
| 5. Invoice totals | `test/domain/billing_test.dart` (rounding, discount, tax), *invoice from visit has correct items and totals* |
| 6. Partial payment balance | *partial payment leaves correct balance…* |
| 7. Instalments settle invoice | same test (3 payments → Paid, over-payment rejected) |
| 8. Overdue derived | billing_test *overdue is derived…*, business_flow_test *overdue derived from due date* |
| 9. Stock deducted on finalised parts | *stock is deducted once when a visit is completed* |
| 10. No double deduction on edit / sync | same + *editing a completed visit adjusts stock by the difference only*, SQL unique index |
| 11. Offline changes survive restart | `test/data/sync_test.dart` *offline changes survive an app restart…* (file DB closed and reopened) |
| 12. Sync retries don't duplicate | sync_test *retries after a lost response…*; SQL test *same op again* |
| 13. No access to other accounts' records | `supabase/tests/schema_test.sql` (read, update, sync overwrite, cross-tenant FK, cross-tenant insert, anon) |
| 14. Exported reports correct | `test/data/reports_export_test.dart` (monthly billing vs. collections, outstanding totals, CSV format, PDF, backup round-trip) |

## Building

### Website (laptop / desktop browser)

The same app also runs in a browser. Sign in with the same account and the
records sync exactly like on a phone.

```bash
tool/build_web.sh        # → build/web/ and build/ServiceRegister-website.zip
```

Upload `build/web` (or the zip) to any static host, e.g. drag it onto
<https://app.netlify.com/drop> or Cloudflare Pages → *Upload assets*. HTTPS
is required (all of these provide it). Run locally with
`flutter run -d chrome --dart-define-from-file=env/prod.json`.

Web specifics:
- The browser keeps its own copy of the records (SQLite in WebAssembly,
  stored in IndexedDB) so it also works through brief internet drops; the
  cloud is the source of truth. `web/sqlite3.wasm` must match the `sqlite3`
  package version and `web/drift_worker.js` is compiled from
  `tool/drift_worker.dart` (`dart compile js -O4 tool/drift_worker.dart -o web/drift_worker.js`).
- Photos, documents and signatures are added from the phone app; the website
  shows them from cloud storage. PDFs and exports download to the
  computer's Downloads folder. SMS and local notifications are phone-only.
- Wide screens get a side navigation rail and a centred, readable page width.

### Android

```bash
flutter build apk --release --dart-define-from-file=env/prod.json   # omit the flag for local-only builds
# → build/app/outputs/flutter-apk/app-release.apk
flutter build appbundle --release --dart-define-from-file=env/prod.json  # for Play Store
```

Release signing: create `android/key.properties` (git-ignored):

```
storeFile=/absolute/path/upload-keystore.jks
storePassword=…
keyAlias=upload
keyPassword=…
```

Create a keystore with
`keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`.
Without `key.properties` the release APK is signed with the debug key — fine
for installing on your own phone, not for the Play Store.

Install on a phone: enable *Developer options → USB debugging*, connect, then
`flutter install` (or copy the APK and open it, allowing "install unknown apps").

### iOS (needs a Mac with full Xcode)

This repository was built on a Mac **without** a full Xcode install, so the iOS
build has not been compiled or run here. Steps:

1. Install Xcode from the App Store, then
   `sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer && sudo xcodebuild -runFirstLaunch`.
2. Install CocoaPods: `brew install cocoapods`.
3. `flutter pub get && cd ios && pod install && cd ..`
4. `open ios/Runner.xcworkspace` → *Runner* target → *Signing & Capabilities*:
   choose your Team (a free Apple ID works for your own device) and a unique
   bundle id (e.g. `com.yourname.serviceregister`).
5. Run on a simulator: `flutter run -d "iPhone 16"` (or pick in Xcode).
   On a device: connect the iPhone, trust the computer, enable Developer Mode,
   then `flutter run --release --dart-define-from-file=env/prod.json`.
6. App Store / TestFlight: `flutter build ipa --dart-define-from-file=env/prod.json`
   (paid Apple Developer account required).

Already configured: camera / photo-library usage texts, URL schemes for
tel / sms / WhatsApp / Google Maps, display name, notification delegate.
If CocoaPods complains about the minimum iOS version, set
`platform :ios, '13.0'` in `ios/Podfile`.

## Folder structure

```
lib/
  main.dart, app.dart          startup, theme, router, background services
  core/
    config/env.dart            build-time config (--dart-define-from-file)
    providers.dart             Riverpod wiring for DB + repositories + settings
    router/app_router.dart     go_router routes (5-tab shell + detail/forms)
    theme/app_theme.dart       design tokens, colours, status colours, components
    utils/                     money (paise), quantity, dates (Indian FY), ids, CSV
    widgets/                   shared UI: cards, chips, form fields, dialogs
  domain/                      pure business rules (no Flutter): billing, numbering,
                               duplicates, drafts, report table, templates,
                               notification planning, amount in words
  data/
    local/                     Drift tables + database
    repositories/              all reads/writes; every write is a transaction that
                               also queues the change for sync
    sync/                      sync engine, Supabase transport, controller, conflicts
  services/                    PDFs, document sharing, backup/restore, notifications,
                               phone/map/WhatsApp actions, auth
  features/                    screens per area (home, companies, machines, visits,
                               billing, inventory, schedule, reports, search,
                               settings, sync, onboarding, attachments, documents)
  l10n/                        ARB strings (English) + generated localizations
supabase/
  migrations/                  schema, RLS, triggers, sync_push, storage bucket
  tests/                       local PostgreSQL test harness for the schema
test/                          unit, repository, sync, report, PDF and widget tests
integration_test/              on-device end-to-end test
assets/fonts/                  Noto Sans (₹ glyph for PDFs), SIL OFL licence
```

## How it works (important design decisions)

**Money** is stored as integer **paise** everywhere (app and server). Line
totals and tax round half-up once per line. No floating point is ever used for
amounts. Quantities are integer thousandths (1.5 m = 1500).

**Invoice status** (Unpaid / Partially paid / Paid / Overdue / Cancelled) is
never stored; it is derived from total, active payment allocations and due
date every time.

**Payments** are separate from invoices: a payment can be split across several
invoices (instalments in either direction) and any unapplied amount is kept as
the company's **advance / credit**, which can be applied later. Payments are
never edited in amount — they are **voided** (with reason) and re-entered.

**Completing a visit** (one transaction): status → completed, machine status /
next maintenance date updated, stock deducted, optional invoice created, and
the amount received on site recorded as a payment applied to that invoice.
The generated invoice / payment ids are derived from the visit id, so a retry
or double tap can't create duplicates. Editing a completed visit is allowed,
asks for confirmation and is written to the visit's **change history**
(field-by-field). An existing invoice is not changed silently.

**Document numbers** (`INV-2627-0001`, `SV-…`, `RCPT-…`: prefix, Indian
financial year, sequence) are computed from the numbers already stored —
not from a resettable counter — inside the insert transaction, and are unique
locally and on the server. Use a different prefix per phone if two phones
create invoices offline at the same time.

**Stock** is the sum of stock movements. Each visit part has exactly one
movement with a deterministic id, so editing / re-saving / re-syncing a visit
updates that movement instead of deducting again. Inventory tracking can be
switched off; parts are still recorded on visits.

**Offline & sync.** The phone's SQLite database is the source of truth for the
UI. Every change is written together with an outbox entry. When signed in, the
app syncs automatically: ~5 s after a change, immediately when the app is
sent to the background or closed, on reconnect, on app resume and every
5 minutes while open (changes made offline wait safely in the outbox):

1. photos/documents are uploaded to private storage,
2. outbox changes are pushed with an `op_id` and the base revision,
3. changes from other phones are pulled (cursor + overlap window).

Conflict rule: *the newer server version wins; a stale local edit is never
written over it*. The losing local edit is kept in **Backup & sync → Edits
needing review**, where the user can keep the saved version or explicitly
re-apply theirs. Local data is bound to the first account that synced it; a
different account cannot sync until the phone's data is removed.

**Backups.** Besides cloud sync there is a one-file backup (zip with all
records + photos) that can be saved to Drive / WhatsApp and restored on another
phone, and a spreadsheet export (one UTF-8 CSV per record type, amounts in
rupees, opens in Excel). The Backup screen lists exactly which record types
still have changes that are only on the phone.

## Implemented

- Home dashboard: today's visits, jobs in progress, upcoming visits, maintenance
  due, reminders, collected vs. billed this month, outstanding, overdue,
  low stock, top balances, visits completed today / week / month.
- Companies: create / edit / archive / restore, auto customer code, search by
  name / phone / code / contact / city, sort, duplicate warning (similar name or
  same phone; never merged), detail with account summary, machines, visits,
  invoices, payments, call / map / WhatsApp actions.
- Machines: PCB / CBC / Other, all fields (serial optional), status, warranty,
  maintenance interval & next due, history, parts replaced, recurring faults,
  total spend.
- Service visits: guided A–F form, quick draft (company + date only), status,
  last-service hint for the machine, multiple spare parts (catalogue or
  unlisted, optionally added to catalogue), charges / discount / optional tax,
  amount received on site, before/after photos, documents, customer signature,
  feedback, next service date, internal notes, complete → shortcuts (service
  report PDF, invoice, payment, schedule next), change history, schedule,
  reschedule, start, cancel, missed-visit marking.
- Invoices: from one or several visits or manual items, editable, cancel,
  bill-to snapshot, configurable tax, PDF with amount in words, UPI / bank
  details, preview / print / share (WhatsApp etc.).
- Payments: cash / UPI / bank / cheque / other, reference, multiple invoices,
  instalments, advance / credit + apply later, void, receipt PDF, filters by
  date / company / method.
- Payment reminders: editable template with placeholders; sent only by the
  user via WhatsApp / SMS / share.
- Inventory: catalogue, stock, low-stock warnings, purchases, adjustments,
  movement history, can be disabled.
- Schedule: upcoming / missed / done visits, reminders (done / reschedule /
  cancel), maintenance due; local notifications (best effort).
- Reports with filters (date range presets, company, machine, category,
  service type) and on-screen preview, CSV and PDF export: business summary,
  company history, machine history, monthly billing & collections,
  outstanding, payments, parts used, stock summary.
- Global search; settings; light / dark theme; English UI strings structured
  for translation (`lib/l10n`).
- Supabase: schema, RLS, storage policies, idempotent sync RPC, email/password
  auth with session in Keychain / Keystore, password reset.

## Not done / needs credentials / known limitations

- **Supabase not connected in this environment** (no credentials). The
  schema and RLS were tested on local PostgreSQL with a stub `auth` schema; the
  client sync protocol was tested against an in-memory fake with the same
  semantics. A real end-to-end run against a Supabase project still has to be
  done once credentials exist.
- **iOS** not built or run (no full Xcode here). See steps above.
- **Localisation**: infrastructure and navigation / common strings are in ARB
  files; most screen texts are still English literals and need extraction
  before adding Hindi / Marathi.
- **Tax**: one rate per visit / invoice; no CGST/SGST/IGST split, HSN/SAC
  codes or e-invoicing. Documents are not certified as GST-compliant.
- Business settings are per phone (included in backup files, not in cloud
  sync). Re-enter them, or restore a backup, on a new phone.
- Notifications are local and best-effort (Android battery savers may delay
  them); there is no background sync while the app is closed.
- Photos download from the cloud on demand (when opened), not in bulk.
- If two phones create the same invoice number offline, the second upload is
  rejected and shown as a sync error; use different prefixes per phone.
- No app lock / PIN yet.

## Next steps

1. Create the Supabase project, apply migrations, add `env/prod.json`, sign in
   on the phone and confirm the first sync (Backup & sync shows 0 pending).
2. Extract remaining UI strings and add `app_hi.arb` / `app_mr.arb`.
3. Optional GST detail (CGST/SGST split, HSN) if needed by customers.
4. App lock, background sync (WorkManager / BGTaskScheduler), cloud sync of
   business settings.
