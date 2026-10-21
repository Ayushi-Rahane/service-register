# Supabase setup (cloud backup & sync)

The app works fully offline without Supabase. Follow these steps to enable
sign-in, automatic cloud backup and multi-phone sync.

## 1. Create the project

1. Create a project at <https://supabase.com/dashboard> (region: Mumbai `ap-south-1` is closest for India).
2. **Project Settings → API**: copy the **Project URL** and the **anon / publishable key**.
   - Never put the `service_role` key in the app or in `env/*.json`.

## 2. Apply the database schema

Either with the Supabase CLI:

```bash
supabase link --project-ref <your-project-ref>
supabase db push            # applies supabase/migrations/*.sql in order
```

or in the dashboard **SQL Editor**, run, in order:

1. `migrations/20261016000000_initial_schema.sql` – tables, constraints, RLS, `sync_push`
2. `migrations/20261016000100_storage.sql` – private `attachments` bucket + policies

## 3. Authentication settings

**Authentication → Providers → Email**: enabled (email + password).

- *Confirm email* ON is recommended. The user then opens the link in the
  confirmation email once before the first sign-in. No deep links are needed.
- **Authentication → URL Configuration**: set *Site URL* to any page you
  control (the confirmation / password-reset links land there).
- Optional: disable public sign-ups after creating your account
  (**Authentication → Settings → Allow new users to sign up = off**) so only you
  can create accounts.

## 4. Configure the app

```bash
cp env/example.json env/dev.json     # env/*.json is git-ignored
# edit env/dev.json with the URL and anon key
flutter run --dart-define-from-file=env/dev.json
```

Release builds take the same flag:
`flutter build apk --release --dart-define-from-file=env/prod.json`.

## Data model & security summary

| Concern | How it is handled |
|---|---|
| Tenancy | Every row has `business_id`. Sign-up trigger creates a business + owner membership. More technicians = more rows in `business_members` (role `technician`). |
| Row Level Security | Enabled on every table. `select/insert/update` only where `is_member(business_id)`. **No delete** grant or policy: records are archived / cancelled / voided. `audit_log` is insert-only. |
| Cross-tenant references | Child tables use composite FKs `(parent_id, business_id)`, so a row can never point to another account's record even with a guessed UUID. |
| Tenant hopping | Trigger forces `business_id` unchanged on update. |
| Money | `BIGINT` paise (exact integers, same as the app). Views `invoice_balances` / `part_stock` expose `NUMERIC(14,2)` rupees. Check constraints keep amounts non-negative and invoice totals consistent. |
| Payments | Trigger rejects allocations above the invoice total or the payment amount, whatever order phones sync in. |
| Stock | Sum of `stock_movements`; one movement per visit part (unique index) → no double deduction. |
| Sync idempotency | `sync_push` records each `op_id` in `sync_ops`; a retried op returns the stored result and changes nothing. |
| Conflicts | Update applies only if the row's `rev` equals the client's base revision (or the newer revision came from the same device). Otherwise the server row is returned as a `conflict` and is not overwritten. |
| Files | Private bucket `attachments`, path `<business_id>/<attachment_id>.<ext>`, readable/writable only by members. |

## Testing the schema locally (no Supabase needed)

`supabase/tests/run_schema_tests.sh` creates a throw-away database on a local
PostgreSQL server, adds a tiny stand-in for Supabase's `auth` schema, applies
the migration and asserts RLS isolation, idempotency, conflicts and financial
constraints:

```bash
supabase/tests/run_schema_tests.sh
# … ALL SCHEMA TESTS PASSED
```

With the Supabase CLI you can also run the real stack: `supabase start` then
`supabase db reset`.

## Two people, same records

Each sign-up gets its own empty business. To let a second account (e.g. a
family member) use the same records as an existing one, edit the two emails
in `share_business.sql` and run it in the SQL Editor. It refuses to run if
the second account already has records of its own.
