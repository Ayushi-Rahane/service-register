-- Run by run_schema_tests.sh. Any failed assertion aborts with an error.
\set ON_ERROR_STOP 1
\set QUIET 1

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-00000000000a', 'a@example.com'),
  ('00000000-0000-0000-0000-00000000000b', 'b@example.com');

do $$ begin
  assert (select count(*) from public.businesses) = 2, 'each sign-up gets a business';
  assert (select count(*) from public.business_members where role = 'owner') = 2;
end $$;

-- Helper (owned by the superuser, callable by everyone) to read sync results.
create function pg_temp.status(r jsonb, i int) returns text language sql as $$ select r -> i ->> 'status' $$;

select set_config('test.a_business', business_id::text, false)
  from public.business_members where user_id = '00000000-0000-0000-0000-00000000000a' \gset

\echo '--- user A pushes records'
set role authenticated;
set request.jwt.claim.sub = '00000000-0000-0000-0000-00000000000a';

do $$
declare r jsonb;
begin
  r := public.sync_push('dev-A', '[
    {"op_id":"10000000-0000-0000-0000-000000000001","table":"companies","id":"c0000000-0000-0000-0000-000000000001","base_rev":0,
     "data":{"id":"c0000000-0000-0000-0000-000000000001","name":"Shree Electronics","phone":"9822012345","code":"C-0001",
             "created_at":"2026-10-16T08:00:00.000Z","updated_at":"2026-10-16T08:00:00.000Z","server_rev":0}}
  ]');
  assert r -> 0 ->> 'status' = 'applied', 'insert applied: ' || r::text;
  assert (r -> 0 ->> 'rev')::int = 1;

  -- Same op again (lost response retry) -> same result, no duplicate, no new revision.
  r := public.sync_push('dev-A', '[
    {"op_id":"10000000-0000-0000-0000-000000000001","table":"companies","id":"c0000000-0000-0000-0000-000000000001","base_rev":0,
     "data":{"id":"c0000000-0000-0000-0000-000000000001","name":"Shree Electronics",
             "created_at":"2026-10-16T08:00:00.000Z","updated_at":"2026-10-16T08:00:00.000Z"}}
  ]');
  assert r -> 0 ->> 'status' = 'applied';
  assert (select count(*) from public.companies) = 1, 'no duplicate row';
  assert (select rev from public.companies) = 1, 'retry did not create a revision';

  -- Normal update based on rev 1.
  r := public.sync_push('dev-A', '[
    {"op_id":"10000000-0000-0000-0000-000000000002","table":"companies","id":"c0000000-0000-0000-0000-000000000001","base_rev":1,
     "data":{"id":"c0000000-0000-0000-0000-000000000001","name":"Shree Electronics","city":"Pune",
             "created_at":"2026-10-16T08:00:00.000Z","updated_at":"2026-10-16T09:00:00.000Z"}}
  ]');
  assert r -> 0 ->> 'status' = 'applied' and (r -> 0 ->> 'rev')::int = 2, r::text;

  -- Stale edit from another device -> conflict, server data untouched.
  r := public.sync_push('dev-OTHER', '[
    {"op_id":"10000000-0000-0000-0000-000000000003","table":"companies","id":"c0000000-0000-0000-0000-000000000001","base_rev":1,
     "data":{"id":"c0000000-0000-0000-0000-000000000001","name":"STALE NAME",
             "created_at":"2026-10-16T08:00:00.000Z","updated_at":"2026-10-16T08:30:00.000Z"}}
  ]');
  assert r -> 0 ->> 'status' = 'conflict', r::text;
  assert r -> 0 -> 'server_row' ->> 'city' = 'Pune';
  assert (select name from public.companies) = 'Shree Electronics', 'stale data did not overwrite';

  -- Non-syncable table and invalid data are rejected per change.
  r := public.sync_push('dev-A', '[
    {"op_id":"10000000-0000-0000-0000-000000000004","table":"business_members","id":"c0000000-0000-0000-0000-000000000009","base_rev":0,"data":{}},
    {"op_id":"10000000-0000-0000-0000-000000000005","table":"companies","id":"c0000000-0000-0000-0000-000000000002","base_rev":0,
     "data":{"name":"  ","created_at":"2026-10-16T08:00:00Z","updated_at":"2026-10-16T08:00:00Z"}}
  ]');
  assert r -> 0 ->> 'status' = 'error' and r -> 1 ->> 'status' = 'error', r::text;
end $$;

\echo '--- billing integrity'
do $$
declare r jsonb;
begin
  r := public.sync_push('dev-A', '[
    {"op_id":"20000000-0000-0000-0000-000000000001","table":"invoices","id":"10000000-aaaa-0000-0000-000000000001","base_rev":0,
     "data":{"invoice_no":"INV-2627-0001","company_id":"c0000000-0000-0000-0000-000000000001","invoice_date":"2026-10-16",
             "due_date":"2026-10-31","bill_to_name":"Shree Electronics","subtotal_paise":200000,"tax_paise":0,"total_paise":200000,
             "created_at":"2026-10-16T08:00:00Z","updated_at":"2026-10-16T08:00:00Z"}},
    {"op_id":"20000000-0000-0000-0000-000000000002","table":"payments","id":"20000000-bbbb-0000-0000-000000000001","base_rev":0,
     "data":{"receipt_no":"RCPT-2627-0001","company_id":"c0000000-0000-0000-0000-000000000001","paid_on":"2026-10-16",
             "amount_paise":250000,"method":"upi","created_at":"2026-10-16T08:00:00Z","updated_at":"2026-10-16T08:00:00Z"}},
    {"op_id":"20000000-0000-0000-0000-000000000003","table":"payment_allocations","id":"30000000-cccc-0000-0000-000000000001","base_rev":0,
     "data":{"payment_id":"20000000-bbbb-0000-0000-000000000001","invoice_id":"10000000-aaaa-0000-0000-000000000001",
             "amount_paise":150000,"created_at":"2026-10-16T08:00:00Z","updated_at":"2026-10-16T08:00:00Z"}},
    {"op_id":"20000000-0000-0000-0000-000000000004","table":"payment_allocations","id":"30000000-cccc-0000-0000-000000000002","base_rev":0,
     "data":{"payment_id":"20000000-bbbb-0000-0000-000000000001","invoice_id":"10000000-aaaa-0000-0000-000000000001",
             "amount_paise":60000,"created_at":"2026-10-16T08:00:00Z","updated_at":"2026-10-16T08:00:00Z"}},
    {"op_id":"20000000-0000-0000-0000-000000000005","table":"invoices","id":"10000000-aaaa-0000-0000-000000000002","base_rev":0,
     "data":{"invoice_no":"INV-2627-0001","company_id":"c0000000-0000-0000-0000-000000000001","invoice_date":"2026-10-16",
             "bill_to_name":"Dup","total_paise":0,"created_at":"2026-10-16T08:00:00Z","updated_at":"2026-10-16T08:00:00Z"}},
    {"op_id":"20000000-0000-0000-0000-000000000006","table":"invoices","id":"10000000-aaaa-0000-0000-000000000003","base_rev":0,
     "data":{"invoice_no":"INV-2627-0009","company_id":"c0000000-0000-0000-0000-000000000001","invoice_date":"2026-10-16",
             "bill_to_name":"Bad total","subtotal_paise":1000,"tax_paise":0,"total_paise":5,"created_at":"2026-10-16T08:00:00Z","updated_at":"2026-10-16T08:00:00Z"}}
  ]');
  assert pg_temp.status(r, 0) = 'applied', r::text;
  assert pg_temp.status(r, 1) = 'applied', r::text;
  assert pg_temp.status(r, 2) = 'applied', r::text;
  assert pg_temp.status(r, 3) = 'error' and r -> 3 ->> 'error' like '%exceeds the invoice balance%', 'over-allocation rejected: ' || r::text;
  assert pg_temp.status(r, 4) = 'error' and r -> 4 ->> 'error' like '%duplicate%', 'duplicate invoice number rejected';
  assert pg_temp.status(r, 5) = 'error', 'inconsistent total rejected';
  assert (select payment_status from public.invoice_balances) = 'partially_paid';
  assert (select outstanding from public.invoice_balances) = 500.00;
end $$;

\echo '--- direct table access rules for A'
do $$
declare n int;
begin
  begin
    delete from public.payments;
    assert false, 'delete must be denied';
  exception when insufficient_privilege then null;
  end;
  update public.companies set business_id = '00000000-0000-0000-0000-0000000000ff';
  assert (select business_id from public.companies) = public.current_business_id(), 'business_id cannot change';
  begin
    update public.audit_log set summary = 'x';
    get diagnostics n = row_count;
    assert n = 0;
  exception when insufficient_privilege then null;
  end;
end $$;

\echo '--- user B cannot see or touch A''s records'
set request.jwt.claim.sub = '00000000-0000-0000-0000-00000000000b';
do $$
declare r jsonb; n int;
begin
  assert (select count(*) from public.companies) = 0, 'B sees no companies';
  assert (select count(*) from public.invoices) = 0, 'B sees no invoices';
  assert (select count(*) from public.invoice_balances) = 0, 'B sees no balances';
  assert (select count(*) from public.sync_ops) = 0, 'B sees no sync results';

  update public.companies set name = 'hacked' where id = 'c0000000-0000-0000-0000-000000000001';
  get diagnostics n = row_count;
  assert n = 0, 'B cannot update A''s company';

  -- Overwrite attempt via sync with A's id.
  r := public.sync_push('dev-B', '[
    {"op_id":"30000000-0000-0000-0000-000000000001","table":"companies","id":"c0000000-0000-0000-0000-000000000001","base_rev":2,
     "data":{"name":"hacked","created_at":"2026-10-16T08:00:00Z","updated_at":"2026-10-16T08:00:00Z"}},
    {"op_id":"30000000-0000-0000-0000-000000000002","table":"machines","id":"d0000000-0000-0000-0000-000000000001","base_rev":0,
     "data":{"company_id":"c0000000-0000-0000-0000-000000000001","name":"Spy","created_at":"2026-10-16T08:00:00Z","updated_at":"2026-10-16T08:00:00Z"}},
    {"op_id":"20000000-0000-0000-0000-000000000001","table":"invoices","id":"10000000-aaaa-0000-0000-000000000001","base_rev":0,"data":{}}
  ]');
  assert pg_temp.status(r, 0) = 'error', 'B cannot overwrite by id: ' || r::text;
  assert pg_temp.status(r, 1) = 'error', 'B cannot attach to A''s company: ' || r::text;
  -- Re-using A's op id does not leak A's stored result.
  assert pg_temp.status(r, 2) is distinct from 'applied' or (r -> 2 ? 'server_row') = false;
  assert (select count(*) from public.machines) = 0;

  -- Direct insert into A's business is refused by RLS.
  begin
    insert into public.companies (id, business_id, name, created_at, updated_at)
    values (gen_random_uuid(), current_setting('test.a_business')::uuid, 'x', now(), now());
    assert false, 'insert into A''s business must fail';
  exception when insufficient_privilege then null;
  end;
  assert (select count(*) from public.companies) = 0;
end $$;

reset role;
do $$ begin
  assert (select name from public.companies where id = 'c0000000-0000-0000-0000-000000000001') = 'Shree Electronics',
    'A''s data intact';
end $$;

\echo '--- anonymous access'
set role anon;
reset request.jwt.claim.sub;
do $$ begin
  begin
    perform count(*) from public.companies;
    assert false, 'anon must not read';
  exception when insufficient_privilege then null;
  end;
  begin
    perform public.sync_push('x', '[]');
    assert false, 'anon must not sync';
  exception when insufficient_privilege then null;
  end;
end $$;
reset role;
\echo 'ALL SCHEMA TESTS PASSED'
