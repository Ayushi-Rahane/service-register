-- Let a second account use the SAME records as an existing account
-- (e.g. father and daughter). Paste into Supabase → SQL Editor, change the
-- two emails if needed, and Run. Safe to run more than once.
--
-- The second account keeps nothing of its own: its empty starter business
-- (created at sign-up) is left unused. If the second account already has
-- records of its own, this stops with an error instead of hiding them.
do $$
declare
  v_owner   uuid := (select id from auth.users where lower(email) = lower('ayushirahane2021@gmail.com'));
  v_member  uuid := (select id from auth.users where lower(email) = lower('m_rahane@yahoo.com'));
  v_shared  uuid;
  v_own     uuid;
  v_records bigint;
begin
  if v_owner is null or v_member is null then
    raise exception 'Both accounts must exist (check the two emails)';
  end if;
  select business_id into v_shared from public.business_members
   where user_id = v_owner order by created_at, business_id limit 1;

  for v_own in
    select business_id from public.business_members
     where user_id = v_member and business_id <> v_shared
  loop
    select (select count(*) from public.companies where business_id = v_own)
         + (select count(*) from public.parts where business_id = v_own)
      into v_records;
    if v_records > 0 then
      raise exception 'The second account already has % records of its own; not merging automatically.', v_records;
    end if;
    delete from public.business_members where user_id = v_member and business_id = v_own;
  end loop;

  insert into public.business_members (business_id, user_id, role)
  values (v_shared, v_member, 'owner')
  on conflict do nothing;
end;
$$;
