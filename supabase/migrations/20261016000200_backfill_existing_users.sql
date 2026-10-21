-- Gives every already-existing auth user (created before the sign-up trigger
-- was installed) a profile, a business and an owner membership. Safe to run
-- more than once.
do $$
declare
  u record;
  v_business uuid;
begin
  for u in
    select au.id, au.raw_user_meta_data
    from auth.users au
    where not exists (select 1 from public.business_members m where m.user_id = au.id)
  loop
    insert into public.profiles (id, full_name)
    values (u.id, u.raw_user_meta_data ->> 'full_name')
    on conflict (id) do nothing;
    insert into public.businesses (name, created_by)
    values (coalesce(u.raw_user_meta_data ->> 'business_name', 'My Service Business'), u.id)
    returning id into v_business;
    insert into public.business_members (business_id, user_id, role)
    values (v_business, u.id, 'owner');
  end loop;
end;
$$;
