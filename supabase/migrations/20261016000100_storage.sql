-- Private bucket for visit photos, documents and signatures.
-- Object paths are "<business_id>/<attachment_id>.<ext>"; access is limited to
-- members of that business.

insert into storage.buckets (id, name, public, file_size_limit)
values ('attachments', 'attachments', false, 20971520)
on conflict (id) do nothing;

create policy attachments_read on storage.objects for select to authenticated
  using (
    bucket_id = 'attachments'
    and public.is_member(((storage.foldername(name))[1])::uuid)
  );

create policy attachments_insert on storage.objects for insert to authenticated
  with check (
    bucket_id = 'attachments'
    and public.is_member(((storage.foldername(name))[1])::uuid)
  );

create policy attachments_update on storage.objects for update to authenticated
  using (
    bucket_id = 'attachments'
    and public.is_member(((storage.foldername(name))[1])::uuid)
  );
