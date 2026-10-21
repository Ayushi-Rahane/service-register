-- =============================================================================
-- Service Register – initial schema
--
-- Conventions
--   * Every business record belongs to a business (tenant). A user sees only
--     businesses they are a member of (RLS). Single technician today; more
--     technicians later = more rows in business_members.
--   * Ids are client-generated UUIDs (records are created offline).
--   * Money is BIGINT paise (₹1 = 100 paise): exact integers, identical to the
--     app's representation, no floating point. Views expose NUMERIC(14,2)
--     rupee amounts for reporting.
--   * Quantities are BIGINT thousandths (1.5 m = 1500).
--   * Nothing is hard-deleted by clients: there is no DELETE grant/policy.
--     Records are archived, cancelled, voided or soft-deleted instead, and
--     foreign keys never cascade into financial records.
--   * Child rows reference parents through (id, business_id) composite foreign
--     keys, so a row can never point at another tenant's record even if its id
--     is known.
--   * rev / server_updated_at are maintained by triggers and drive sync.
-- =============================================================================

create extension if not exists pgcrypto;

-- -----------------------------------------------------------------------------
-- Tenancy
-- -----------------------------------------------------------------------------

create table public.businesses (
  id uuid primary key default gen_random_uuid(),
  name text not null default 'My Service Business',
  created_by uuid not null references auth.users (id),
  created_at timestamptz not null default now()
);

create table public.business_members (
  business_id uuid not null references public.businesses (id),
  user_id uuid not null references auth.users (id),
  role text not null default 'owner' check (role in ('owner', 'technician')),
  created_at timestamptz not null default now(),
  primary key (business_id, user_id)
);
create index business_members_user_idx on public.business_members (user_id);

create table public.profiles (
  id uuid primary key references auth.users (id),
  full_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Membership check used by every policy. SECURITY DEFINER so it can read
-- business_members without recursive RLS evaluation.
create or replace function public.is_member(p_business uuid)
returns boolean
language sql stable security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.business_members m
    where m.business_id = p_business and m.user_id = auth.uid()
  );
$$;

-- The business new rows are written to (the user's first membership).
create or replace function public.current_business_id()
returns uuid
language sql stable security definer
set search_path = ''
as $$
  select m.business_id from public.business_members m
  where m.user_id = auth.uid()
  order by m.created_at, m.business_id
  limit 1;
$$;

-- New sign-up => profile + own business + owner membership.
create or replace function public.handle_new_user()
returns trigger
language plpgsql security definer
set search_path = ''
as $$
declare
  v_business uuid;
begin
  insert into public.profiles (id, full_name)
  values (new.id, new.raw_user_meta_data ->> 'full_name')
  on conflict (id) do nothing;

  insert into public.businesses (name, created_by)
  values (coalesce(new.raw_user_meta_data ->> 'business_name', 'My Service Business'), new.id)
  returning id into v_business;

  insert into public.business_members (business_id, user_id, role)
  values (v_business, new.id, 'owner');
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- -----------------------------------------------------------------------------
-- Sync bookkeeping trigger: server-managed revision and timestamp.
-- -----------------------------------------------------------------------------

create or replace function public.tg_sync_row()
returns trigger
language plpgsql
as $$
begin
  if tg_op = 'INSERT' then
    new.rev := 1;
    if new.business_id is null then
      new.business_id := public.current_business_id();
    end if;
  else
    new.rev := old.rev + 1;
    new.business_id := old.business_id;   -- rows can never move tenants
    new.created_at := old.created_at;
  end if;
  new.server_updated_at := clock_timestamp();
  return new;
end;
$$;

-- -----------------------------------------------------------------------------
-- Business tables
-- -----------------------------------------------------------------------------

create table public.companies (
  id uuid primary key,
  business_id uuid not null references public.businesses (id),
  code text,
  name text not null check (length(btrim(name)) > 0),
  contact_person text,
  phone text,
  alt_phone text,
  email text,
  address text,
  city text,
  state text,
  pincode text,
  gstin text check (gstin is null or length(gstin) <= 20),
  notes text,
  archived_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  rev bigint not null default 1,
  server_updated_at timestamptz not null default now(),
  updated_by_device text,
  unique (id, business_id)
);
create index companies_business_name_idx on public.companies (business_id, lower(name));
create index companies_sync_idx on public.companies (business_id, server_updated_at);

create table public.machines (
  id uuid primary key,
  business_id uuid not null references public.businesses (id),
  company_id uuid not null,
  name text not null check (length(btrim(name)) > 0),
  category text not null default 'other' check (category in ('pcb', 'cbc', 'other')),
  manufacturer text,
  model text,
  serial_number text,
  location text,
  installed_on date,
  warranty_until date,
  service_interval_days integer check (service_interval_days is null or service_interval_days > 0),
  next_service_due date,
  status text not null default 'operational'
    check (status in ('operational', 'needs_attention', 'under_repair', 'decommissioned')),
  notes text,
  archived_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  rev bigint not null default 1,
  server_updated_at timestamptz not null default now(),
  updated_by_device text,
  unique (id, business_id),
  foreign key (company_id, business_id) references public.companies (id, business_id)
);
create index machines_company_idx on public.machines (company_id);
create index machines_serial_idx on public.machines (business_id, serial_number);
create index machines_sync_idx on public.machines (business_id, server_updated_at);

create table public.parts (
  id uuid primary key,
  business_id uuid not null references public.businesses (id),
  name text not null check (length(btrim(name)) > 0),
  part_number text,
  category text,
  unit text not null default 'pcs',
  min_stock_milli bigint not null default 0 check (min_stock_milli >= 0),
  purchase_paise bigint check (purchase_paise is null or purchase_paise >= 0),
  selling_paise bigint check (selling_paise is null or selling_paise >= 0),
  supplier_name text,
  supplier_contact text,
  notes text,
  archived_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  rev bigint not null default 1,
  server_updated_at timestamptz not null default now(),
  updated_by_device text,
  unique (id, business_id)
);
create index parts_sync_idx on public.parts (business_id, server_updated_at);

create table public.invoices (
  id uuid primary key,
  business_id uuid not null references public.businesses (id),
  invoice_no text not null,
  company_id uuid not null,
  invoice_date date not null,
  due_date date,
  bill_to_name text not null,
  bill_to_address text,
  bill_to_phone text,
  bill_to_gstin text,
  discount_paise bigint not null default 0 check (discount_paise >= 0),
  tax_label text,
  tax_rate_bp integer not null default 0 check (tax_rate_bp between 0 and 10000),
  subtotal_paise bigint not null default 0 check (subtotal_paise >= 0),
  tax_paise bigint not null default 0 check (tax_paise >= 0),
  total_paise bigint not null default 0 check (total_paise >= 0),
  notes text,
  cancelled_at timestamptz,
  cancel_reason text,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  rev bigint not null default 1,
  server_updated_at timestamptz not null default now(),
  updated_by_device text,
  unique (id, business_id),
  unique (business_id, invoice_no),
  check (due_date is null or due_date >= invoice_date),
  check (total_paise = subtotal_paise - least(discount_paise, subtotal_paise) + tax_paise),
  foreign key (company_id, business_id) references public.companies (id, business_id)
);
create index invoices_company_idx on public.invoices (company_id);
create index invoices_sync_idx on public.invoices (business_id, server_updated_at);

create table public.service_visits (
  id uuid primary key,
  business_id uuid not null references public.businesses (id),
  visit_no text not null,
  company_id uuid not null,
  machine_id uuid,
  visit_date date not null,
  arrival_time text check (arrival_time is null or arrival_time ~ '^[0-2][0-9]:[0-5][0-9]$'),
  departure_time text check (departure_time is null or departure_time ~ '^[0-2][0-9]:[0-5][0-9]$'),
  service_type text not null default 'routine_maintenance'
    check (service_type in ('routine_maintenance', 'breakdown_repair', 'installation',
                            'inspection', 'emergency', 'other')),
  status text not null default 'in_progress'
    check (status in ('scheduled', 'in_progress', 'completed', 'cancelled')),
  technician_name text,
  reported_problem text,
  symptoms text,
  diagnosis text,
  root_cause text,
  work_done text,
  actions_taken text,
  tests_performed text,
  machine_status_after text
    check (machine_status_after is null or machine_status_after in
           ('operational', 'needs_attention', 'under_repair', 'decommissioned')),
  recommendations text,
  labour_paise bigint not null default 0 check (labour_paise >= 0),
  travel_paise bigint not null default 0 check (travel_paise >= 0),
  discount_paise bigint not null default 0 check (discount_paise >= 0),
  tax_rate_bp integer not null default 0 check (tax_rate_bp between 0 and 10000),
  parts_total_paise bigint not null default 0 check (parts_total_paise >= 0),
  total_paise bigint not null default 0 check (total_paise >= 0),
  onsite_payment_paise bigint not null default 0 check (onsite_payment_paise >= 0),
  onsite_payment_method text,
  customer_feedback text,
  signed_by text,
  next_service_date date,
  internal_notes text,
  completed_at timestamptz,
  invoice_id uuid,
  archived_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  rev bigint not null default 1,
  server_updated_at timestamptz not null default now(),
  updated_by_device text,
  unique (id, business_id),
  unique (business_id, visit_no),
  check (status <> 'completed' or completed_at is not null),
  foreign key (company_id, business_id) references public.companies (id, business_id),
  foreign key (machine_id, business_id) references public.machines (id, business_id),
  foreign key (invoice_id, business_id) references public.invoices (id, business_id)
);
create index service_visits_company_idx on public.service_visits (company_id, visit_date);
create index service_visits_machine_idx on public.service_visits (machine_id, visit_date);
create index service_visits_date_idx on public.service_visits (business_id, visit_date);
create index service_visits_invoice_idx on public.service_visits (invoice_id);
create index service_visits_sync_idx on public.service_visits (business_id, server_updated_at);

create table public.visit_parts (
  id uuid primary key,
  business_id uuid not null references public.businesses (id),
  visit_id uuid not null,
  part_id uuid,
  part_name text not null check (length(btrim(part_name)) > 0),
  part_number text,
  qty_milli bigint not null check (qty_milli > 0),
  unit_cost_paise bigint check (unit_cost_paise is null or unit_cost_paise >= 0),
  unit_price_paise bigint not null default 0 check (unit_price_paise >= 0),
  sort_order integer not null default 0,
  deleted_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  rev bigint not null default 1,
  server_updated_at timestamptz not null default now(),
  updated_by_device text,
  unique (id, business_id),
  foreign key (visit_id, business_id) references public.service_visits (id, business_id),
  foreign key (part_id, business_id) references public.parts (id, business_id)
);
create index visit_parts_visit_idx on public.visit_parts (visit_id);
create index visit_parts_part_idx on public.visit_parts (part_id);
create index visit_parts_sync_idx on public.visit_parts (business_id, server_updated_at);

-- Stock is the SUM of movements; never a mutable counter. Visit usage has
-- exactly one movement per visit part (deterministic id), so it cannot be
-- applied twice.
create table public.stock_movements (
  id uuid primary key,
  business_id uuid not null references public.businesses (id),
  part_id uuid not null,
  kind text not null check (kind in ('opening', 'purchase', 'adjustment', 'visit_usage')),
  qty_milli bigint not null check (qty_milli <> 0),
  unit_cost_paise bigint check (unit_cost_paise is null or unit_cost_paise >= 0),
  visit_id uuid,
  visit_part_id uuid,
  occurred_on date not null,
  notes text,
  deleted_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  rev bigint not null default 1,
  server_updated_at timestamptz not null default now(),
  updated_by_device text,
  unique (id, business_id),
  check (kind <> 'visit_usage' or (visit_part_id is not null and qty_milli < 0)),
  check (kind <> 'purchase' or qty_milli > 0),
  foreign key (part_id, business_id) references public.parts (id, business_id),
  foreign key (visit_id, business_id) references public.service_visits (id, business_id),
  foreign key (visit_part_id, business_id) references public.visit_parts (id, business_id)
);
create unique index stock_movements_one_per_visit_part
  on public.stock_movements (visit_part_id) where visit_part_id is not null;
create index stock_movements_part_idx on public.stock_movements (part_id);
create index stock_movements_sync_idx on public.stock_movements (business_id, server_updated_at);

create table public.invoice_items (
  id uuid primary key,
  business_id uuid not null references public.businesses (id),
  invoice_id uuid not null,
  visit_id uuid,
  kind text not null default 'other' check (kind in ('labour', 'part', 'travel', 'other')),
  description text not null check (length(btrim(description)) > 0),
  qty_milli bigint not null default 1000 check (qty_milli > 0),
  unit_price_paise bigint not null default 0 check (unit_price_paise >= 0),
  amount_paise bigint not null default 0 check (amount_paise >= 0),
  sort_order integer not null default 0,
  deleted_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  rev bigint not null default 1,
  server_updated_at timestamptz not null default now(),
  updated_by_device text,
  unique (id, business_id),
  foreign key (invoice_id, business_id) references public.invoices (id, business_id),
  foreign key (visit_id, business_id) references public.service_visits (id, business_id)
);
create index invoice_items_invoice_idx on public.invoice_items (invoice_id);
create index invoice_items_sync_idx on public.invoice_items (business_id, server_updated_at);

create table public.payments (
  id uuid primary key,
  business_id uuid not null references public.businesses (id),
  receipt_no text not null,
  company_id uuid not null,
  paid_on date not null,
  amount_paise bigint not null check (amount_paise > 0),
  method text not null default 'cash'
    check (method in ('cash', 'upi', 'bank_transfer', 'cheque', 'other')),
  reference text,
  notes text,
  voided_at timestamptz,
  void_reason text,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  rev bigint not null default 1,
  server_updated_at timestamptz not null default now(),
  updated_by_device text,
  unique (id, business_id),
  unique (business_id, receipt_no),
  foreign key (company_id, business_id) references public.companies (id, business_id)
);
create index payments_company_idx on public.payments (company_id, paid_on);
create index payments_sync_idx on public.payments (business_id, server_updated_at);

create table public.payment_allocations (
  id uuid primary key,
  business_id uuid not null references public.businesses (id),
  payment_id uuid not null,
  invoice_id uuid not null,
  amount_paise bigint not null check (amount_paise > 0),
  deleted_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  rev bigint not null default 1,
  server_updated_at timestamptz not null default now(),
  updated_by_device text,
  unique (id, business_id),
  foreign key (payment_id, business_id) references public.payments (id, business_id),
  foreign key (invoice_id, business_id) references public.invoices (id, business_id)
);
create index payment_allocations_invoice_idx on public.payment_allocations (invoice_id);
create index payment_allocations_payment_idx on public.payment_allocations (payment_id);
create index payment_allocations_sync_idx on public.payment_allocations (business_id, server_updated_at);

create table public.reminders (
  id uuid primary key,
  business_id uuid not null references public.businesses (id),
  kind text not null default 'follow_up'
    check (kind in ('follow_up', 'payment', 'maintenance', 'other')),
  title text not null check (length(btrim(title)) > 0),
  notes text,
  due_date date not null,
  due_time text check (due_time is null or due_time ~ '^[0-2][0-9]:[0-5][0-9]$'),
  company_id uuid,
  machine_id uuid,
  invoice_id uuid,
  status text not null default 'pending' check (status in ('pending', 'done', 'cancelled')),
  done_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  rev bigint not null default 1,
  server_updated_at timestamptz not null default now(),
  updated_by_device text,
  unique (id, business_id),
  foreign key (company_id, business_id) references public.companies (id, business_id),
  foreign key (machine_id, business_id) references public.machines (id, business_id),
  foreign key (invoice_id, business_id) references public.invoices (id, business_id)
);
create index reminders_due_idx on public.reminders (business_id, status, due_date);
create index reminders_sync_idx on public.reminders (business_id, server_updated_at);

create table public.attachments (
  id uuid primary key,
  business_id uuid not null references public.businesses (id),
  entity_type text not null check (entity_type in ('visit', 'machine', 'company', 'invoice')),
  entity_id uuid not null,
  kind text not null check (kind in ('photo_before', 'photo_after', 'document', 'signature')),
  file_name text not null,
  mime_type text,
  size_bytes bigint check (size_bytes is null or size_bytes >= 0),
  caption text,
  storage_path text,
  deleted_at timestamptz,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  rev bigint not null default 1,
  server_updated_at timestamptz not null default now(),
  updated_by_device text,
  unique (id, business_id),
  -- Files must live in the business's own storage folder.
  check (storage_path is null or storage_path like business_id::text || '/%')
);
create index attachments_entity_idx on public.attachments (entity_type, entity_id);
create index attachments_sync_idx on public.attachments (business_id, server_updated_at);

-- Append-only change history (no UPDATE policy).
create table public.audit_log (
  id uuid primary key,
  business_id uuid not null references public.businesses (id),
  entity_type text not null,
  entity_id uuid not null,
  action text not null,
  summary text,
  changes text,
  actor text,
  created_at timestamptz not null,
  updated_at timestamptz not null,
  rev bigint not null default 1,
  server_updated_at timestamptz not null default now(),
  updated_by_device text,
  unique (id, business_id)
);
create index audit_log_entity_idx on public.audit_log (entity_type, entity_id, created_at);
create index audit_log_sync_idx on public.audit_log (business_id, server_updated_at);

-- Applied sync operations (idempotency of retries).
create table public.sync_ops (
  op_id uuid primary key,
  business_id uuid not null references public.businesses (id),
  result jsonb not null,
  created_at timestamptz not null default now()
);
create index sync_ops_created_idx on public.sync_ops (created_at);

-- -----------------------------------------------------------------------------
-- Allocation integrity: a payment can never be applied beyond the invoice
-- total or beyond the payment amount, whatever order devices sync in.
-- -----------------------------------------------------------------------------

create or replace function public.tg_check_allocation()
returns trigger
language plpgsql
as $$
declare
  v_invoice_total bigint;
  v_invoice_cancelled timestamptz;
  v_payment_amount bigint;
  v_allocated_invoice bigint;
  v_allocated_payment bigint;
begin
  if new.deleted_at is not null then
    return new;
  end if;
  select total_paise, cancelled_at into v_invoice_total, v_invoice_cancelled
    from public.invoices where id = new.invoice_id for update;
  select amount_paise into v_payment_amount
    from public.payments where id = new.payment_id for update;
  if v_invoice_cancelled is not null then
    raise exception 'Cannot apply a payment to a cancelled invoice';
  end if;

  select coalesce(sum(a.amount_paise), 0) into v_allocated_invoice
    from public.payment_allocations a join public.payments p on p.id = a.payment_id
    where a.invoice_id = new.invoice_id and a.deleted_at is null
      and p.voided_at is null and a.id <> new.id;
  select coalesce(sum(a.amount_paise), 0) into v_allocated_payment
    from public.payment_allocations a
    where a.payment_id = new.payment_id and a.deleted_at is null and a.id <> new.id;

  if v_allocated_invoice + new.amount_paise > v_invoice_total then
    raise exception 'Allocation exceeds the invoice balance';
  end if;
  if v_allocated_payment + new.amount_paise > v_payment_amount then
    raise exception 'Allocation exceeds the payment amount';
  end if;
  return new;
end;
$$;

create trigger payment_allocations_check
  before insert or update on public.payment_allocations
  for each row execute function public.tg_check_allocation();

-- -----------------------------------------------------------------------------
-- Triggers, RLS and grants for all synced tables
-- -----------------------------------------------------------------------------

create or replace function public.sync_tables()
returns text[]
language sql immutable
as $$
  select array[
    'companies', 'machines', 'parts', 'invoices', 'service_visits', 'visit_parts',
    'stock_movements', 'invoice_items', 'payments', 'payment_allocations',
    'reminders', 'attachments', 'audit_log'
  ];
$$;

do $$
declare
  t text;
begin
  foreach t in array public.sync_tables() loop
    execute format(
      'create trigger %I before insert or update on public.%I
         for each row execute function public.tg_sync_row()', t || '_sync_row', t);
    execute format('alter table public.%I enable row level security', t);
    execute format(
      'create policy %I on public.%I for select to authenticated
         using (public.is_member(business_id))', t || '_select', t);
    execute format(
      'create policy %I on public.%I for insert to authenticated
         with check (public.is_member(business_id))', t || '_insert', t);
    if t <> 'audit_log' then
      execute format(
        'create policy %I on public.%I for update to authenticated
           using (public.is_member(business_id))
           with check (public.is_member(business_id))', t || '_update', t);
    end if;
    execute format('revoke all on public.%I from anon', t);
    execute format('revoke delete, truncate on public.%I from authenticated', t);
    execute format('grant select, insert, update on public.%I to authenticated', t);
  end loop;
end;
$$;

alter table public.businesses enable row level security;
alter table public.business_members enable row level security;
alter table public.profiles enable row level security;
alter table public.sync_ops enable row level security;

create policy businesses_select on public.businesses for select to authenticated
  using (public.is_member(id));
create policy businesses_update on public.businesses for update to authenticated
  using (public.is_member(id)) with check (public.is_member(id));
create policy business_members_select on public.business_members for select to authenticated
  using (user_id = auth.uid() or public.is_member(business_id));
create policy profiles_select on public.profiles for select to authenticated
  using (id = auth.uid());
create policy profiles_update on public.profiles for update to authenticated
  using (id = auth.uid()) with check (id = auth.uid());
create policy sync_ops_select on public.sync_ops for select to authenticated
  using (public.is_member(business_id));
create policy sync_ops_insert on public.sync_ops for insert to authenticated
  with check (public.is_member(business_id));

revoke all on public.businesses, public.business_members, public.profiles, public.sync_ops from anon;
revoke delete, truncate on public.businesses, public.business_members, public.profiles, public.sync_ops
  from authenticated;
grant select, update on public.businesses to authenticated;
grant select on public.business_members to authenticated;
grant select, update on public.profiles to authenticated;
grant select, insert on public.sync_ops to authenticated;

-- -----------------------------------------------------------------------------
-- sync_push: apply a batch of client changes.
--
-- For each change {op_id, table, id, base_rev, data}:
--   * op_id already applied            -> return the stored result (idempotent)
--   * row does not exist (for caller)  -> insert
--   * row.rev = base_rev, or the newer revision came from this same device
--                                      -> update
--   * otherwise                        -> 'conflict' + current server row; the
--                                         newer server data is NOT overwritten
-- Runs as the caller (SECURITY INVOKER), so RLS applies to every statement.
-- Each change is isolated: one failing change does not roll back the others.
-- -----------------------------------------------------------------------------

create or replace function public.sync_push(p_device_id text, p_changes jsonb)
returns jsonb
language plpgsql
security invoker
set search_path = public
as $$
declare
  v_business uuid := public.current_business_id();
  v_change jsonb;
  v_results jsonb := '[]'::jsonb;
  v_result jsonb;
  v_prior jsonb;
  v_op uuid;
  v_table text;
  v_id uuid;
  v_base bigint;
  v_data jsonb;
  v_rev bigint;
  v_device text;
  v_row jsonb;
  v_cols text;
  v_update_cols text;
begin
  if auth.uid() is null then
    raise exception 'Not signed in' using errcode = '28000';
  end if;
  if v_business is null then
    raise exception 'No business for this user' using errcode = '28000';
  end if;
  if jsonb_typeof(p_changes) <> 'array' or jsonb_array_length(p_changes) > 500 then
    raise exception 'p_changes must be an array of at most 500 changes';
  end if;

  for v_change in select value from jsonb_array_elements(p_changes) loop
    v_op := (v_change ->> 'op_id')::uuid;
    select s.result into v_prior from public.sync_ops s where s.op_id = v_op;
    if found then
      v_results := v_results || jsonb_build_array(v_prior);
      continue;
    end if;

    begin
      v_table := v_change ->> 'table';
      if v_table is null or not (v_table = any (public.sync_tables())) then
        raise exception 'Table % cannot be synced', v_table;
      end if;
      v_id := (v_change ->> 'id')::uuid;
      v_base := coalesce((v_change ->> 'base_rev')::bigint, 0);
      v_data := ((v_change -> 'data')
                  - 'business_id' - 'rev' - 'server_updated_at' - 'updated_by_device')
                || jsonb_build_object('id', v_id, 'business_id', v_business,
                                      'updated_by_device', p_device_id);

      -- Columns present in both the payload and the table.
      select string_agg(quote_ident(c.column_name), ', ' order by c.ordinal_position),
             string_agg(quote_ident(c.column_name), ', ' order by c.ordinal_position)
               filter (where c.column_name not in ('id', 'business_id', 'created_at'))
        into v_cols, v_update_cols
        from information_schema.columns c
       where c.table_schema = 'public' and c.table_name = v_table
         and c.column_name not in ('rev', 'server_updated_at')
         and v_data ? c.column_name;

      v_rev := null;
      execute format(
        'select t.rev, t.updated_by_device, to_jsonb(t) from public.%I t where t.id = $1 for update',
        v_table)
        into v_rev, v_device, v_row
        using v_id;

      if v_rev is null then
        execute format(
          'insert into public.%1$I (%2$s) select %2$s from jsonb_populate_record(null::public.%1$I, $1) returning rev',
          v_table, v_cols)
          into v_rev
          using v_data;
        v_result := jsonb_build_object('op_id', v_op, 'status', 'applied', 'rev', v_rev);
      elsif v_rev = v_base or v_device = p_device_id then
        execute format(
          'update public.%1$I t set (%2$s) = (select %2$s from jsonb_populate_record(null::public.%1$I, $1)) where t.id = $2 returning t.rev',
          v_table, v_update_cols)
          into v_rev
          using v_data, v_id;
        if v_rev is null then
          raise exception 'Update was not permitted';
        end if;
        v_result := jsonb_build_object('op_id', v_op, 'status', 'applied', 'rev', v_rev);
      else
        v_result := jsonb_build_object('op_id', v_op, 'status', 'conflict',
                                       'rev', v_rev, 'server_row', v_row);
      end if;

      insert into public.sync_ops (op_id, business_id, result)
      values (v_op, v_business, v_result);
    exception when others then
      -- Not recorded in sync_ops, so the client can retry after a fix.
      v_result := jsonb_build_object('op_id', v_op, 'status', 'error', 'error', sqlerrm);
    end;
    v_results := v_results || jsonb_build_array(v_result);
  end loop;
  return v_results;
end;
$$;

revoke all on function public.sync_push(text, jsonb) from public, anon;
grant execute on function public.sync_push(text, jsonb) to authenticated;
grant execute on function public.current_business_id() to authenticated;
grant execute on function public.is_member(uuid) to authenticated;

-- -----------------------------------------------------------------------------
-- Reporting views (respect RLS via security_invoker). Amounts in rupees.
-- -----------------------------------------------------------------------------

create view public.invoice_balances with (security_invoker = true) as
select
  i.id,
  i.business_id,
  i.invoice_no,
  i.company_id,
  i.invoice_date,
  i.due_date,
  (i.total_paise / 100.0)::numeric(14, 2) as total,
  (coalesce(pa.paid, 0) / 100.0)::numeric(14, 2) as paid,
  ((i.total_paise - coalesce(pa.paid, 0)) / 100.0)::numeric(14, 2) as outstanding,
  case
    when i.cancelled_at is not null then 'cancelled'
    when i.total_paise - coalesce(pa.paid, 0) <= 0 then 'paid'
    when i.due_date < current_date then 'overdue'
    when coalesce(pa.paid, 0) > 0 then 'partially_paid'
    else 'unpaid'
  end as payment_status
from public.invoices i
left join (
  select a.invoice_id, sum(a.amount_paise) as paid
  from public.payment_allocations a
  join public.payments p on p.id = a.payment_id
  where a.deleted_at is null and p.voided_at is null
  group by a.invoice_id
) pa on pa.invoice_id = i.id;

create view public.part_stock with (security_invoker = true) as
select p.id, p.business_id, p.name, p.part_number,
       coalesce(sum(m.qty_milli) filter (where m.deleted_at is null), 0) as stock_milli
from public.parts p
left join public.stock_movements m on m.part_id = p.id
group by p.id;

grant select on public.invoice_balances, public.part_stock to authenticated;
