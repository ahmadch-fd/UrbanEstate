-- Urban Estate database setup
-- Run this in Supabase Dashboard > SQL Editor.

create extension if not exists "pgcrypto";

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  email text not null default '',
  phone text not null default '',
  avatar_url text,
  location text not null default '',
  date_of_birth text not null default '',
  role text not null default 'user' check (role in ('user', 'superadmin')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.properties (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  location text not null default '',
  city text not null default '',
  province text not null default '',
  tenant_type text not null default '',
  property_type text not null default '',
  bedrooms text not null default '',
  bathrooms text not null default '',
  available_from text not null default '',
  balcony text not null default '',
  floor_no text not null default '',
  area_sqft text not null default '',
  age_of_house text not null default '',
  price text not null default '',
  predicted_price text,
  price_for text not null default '',
  purpose text not null default '',
  description text not null default '',
  features text[] not null default '{}',
  included_bills text[] not null default '{}',
  latitude text not null default '',
  longitude text not null default '',
  image_url text,
  image_urls text[] not null default '{}',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.conversations (
  id uuid primary key default gen_random_uuid(),
  property_id uuid not null references public.properties(id) on delete cascade,
  buyer_id uuid not null references public.profiles(id) on delete cascade,
  owner_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (property_id, buyer_id, owner_id)
);

create table if not exists public.messages (
  id uuid primary key default gen_random_uuid(),
  conversation_id uuid not null references public.conversations(id) on delete cascade,
  sender_id uuid not null references public.profiles(id) on delete cascade,
  body text not null,
  attachment_url text,
  attachment_type text,
  created_at timestamptz not null default now()
);

create table if not exists public.property_views (
  user_id uuid not null references public.profiles(id) on delete cascade,
  property_id uuid not null references public.properties(id) on delete cascade,
  viewed_at timestamptz not null default now(),
  primary key (user_id, property_id)
);

create table if not exists public.pakistan_locations (
  id uuid primary key default gen_random_uuid(),
  province text not null,
  city text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (province, city)
);

alter table public.properties
add column if not exists image_urls text[] not null default '{}';

alter table public.properties
add column if not exists tenant_type text not null default '';

alter table public.profiles
add column if not exists date_of_birth text not null default '';

alter table public.messages
add column if not exists attachment_url text;

alter table public.messages
add column if not exists attachment_type text;

alter table public.profiles enable row level security;
alter table public.properties enable row level security;
alter table public.conversations enable row level security;
alter table public.messages enable row level security;
alter table public.property_views enable row level security;
alter table public.pakistan_locations enable row level security;

create or replace function public.is_superadmin()
returns boolean
language sql
security definer
set search_path = public
as $$
  select exists (
    select 1
    from public.profiles
    where id = auth.uid()
      and role = 'superadmin'
  );
$$;

drop policy if exists "profiles are readable by signed in users" on public.profiles;
create policy "profiles are readable by signed in users"
on public.profiles for select
to authenticated
using (true);

drop policy if exists "users can update own profile" on public.profiles;
create policy "users can update own profile"
on public.profiles for update
to authenticated
using (id = auth.uid() or public.is_superadmin())
with check (id = auth.uid() or public.is_superadmin());

drop policy if exists "users can insert own profile" on public.profiles;
create policy "users can insert own profile"
on public.profiles for insert
to authenticated
with check (id = auth.uid());

drop policy if exists "superadmin can delete profiles" on public.profiles;
create policy "superadmin can delete profiles"
on public.profiles for delete
to authenticated
using (public.is_superadmin());

drop policy if exists "properties feed is readable" on public.properties;
create policy "properties feed is readable"
on public.properties for select
to authenticated
using (true);

drop policy if exists "users can post properties" on public.properties;
create policy "users can post properties"
on public.properties for insert
to authenticated
with check (owner_id = auth.uid());

drop policy if exists "owners and superadmin can update properties" on public.properties;
drop policy if exists "owners can update properties" on public.properties;
create policy "owners can update properties"
on public.properties for update
to authenticated
using (owner_id = auth.uid() or public.is_superadmin())
with check (owner_id = auth.uid() or public.is_superadmin());

drop policy if exists "owners and superadmin can delete properties" on public.properties;
drop policy if exists "owners can delete properties" on public.properties;
create policy "owners can delete properties"
on public.properties for delete
to authenticated
using (owner_id = auth.uid() or public.is_superadmin());

drop policy if exists "users can read own property views" on public.property_views;
create policy "users can read own property views"
on public.property_views for select
to authenticated
using (user_id = auth.uid());

drop policy if exists "users can insert own property views" on public.property_views;
create policy "users can insert own property views"
on public.property_views for insert
to authenticated
with check (user_id = auth.uid());

drop policy if exists "users can update own property views" on public.property_views;
create policy "users can update own property views"
on public.property_views for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());

drop policy if exists "users can delete own property views" on public.property_views;
create policy "users can delete own property views"
on public.property_views for delete
to authenticated
using (user_id = auth.uid());

drop policy if exists "signed in users can read pakistan locations" on public.pakistan_locations;
create policy "signed in users can read pakistan locations"
on public.pakistan_locations for select
to authenticated
using (true);

drop policy if exists "superadmin can insert pakistan locations" on public.pakistan_locations;
create policy "superadmin can insert pakistan locations"
on public.pakistan_locations for insert
to authenticated
with check (public.is_superadmin());

drop policy if exists "superadmin can update pakistan locations" on public.pakistan_locations;
create policy "superadmin can update pakistan locations"
on public.pakistan_locations for update
to authenticated
using (public.is_superadmin())
with check (public.is_superadmin());

drop policy if exists "superadmin can delete pakistan locations" on public.pakistan_locations;
create policy "superadmin can delete pakistan locations"
on public.pakistan_locations for delete
to authenticated
using (public.is_superadmin());

insert into public.pakistan_locations (province, city)
values
  ('Punjab', 'Lahore'),
  ('Punjab', 'Rawalpindi'),
  ('Punjab', 'Faisalabad'),
  ('Punjab', 'Multan'),
  ('Punjab', 'Gujranwala'),
  ('Punjab', 'Sialkot'),
  ('Sindh', 'Karachi'),
  ('Sindh', 'Hyderabad'),
  ('Sindh', 'Sukkur'),
  ('Sindh', 'Larkana'),
  ('KPK', 'Peshawar'),
  ('KPK', 'Abbottabad'),
  ('KPK', 'Mardan'),
  ('KPK', 'Swat'),
  ('Balochistan', 'Quetta'),
  ('Balochistan', 'Gwadar'),
  ('Balochistan', 'Turbat'),
  ('Balochistan', 'Khuzdar'),
  ('Islamabad Capital Territory', 'Islamabad'),
  ('Azad Kashmir', 'Muzaffarabad'),
  ('Azad Kashmir', 'Mirpur'),
  ('Azad Kashmir', 'Rawalakot'),
  ('Gilgit-Baltistan', 'Gilgit'),
  ('Gilgit-Baltistan', 'Skardu'),
  ('Gilgit-Baltistan', 'Hunza')
on conflict (province, city) do nothing;

drop policy if exists "conversation participants can read conversations" on public.conversations;
create policy "conversation participants can read conversations"
on public.conversations for select
to authenticated
using (buyer_id = auth.uid() or owner_id = auth.uid());

drop policy if exists "buyers can create conversations" on public.conversations;
create policy "buyers can create conversations"
on public.conversations for insert
to authenticated
with check (buyer_id = auth.uid() and owner_id <> auth.uid());

drop policy if exists "conversation participants can update conversations" on public.conversations;
create policy "conversation participants can update conversations"
on public.conversations for update
to authenticated
using (buyer_id = auth.uid() or owner_id = auth.uid())
with check (buyer_id = auth.uid() or owner_id = auth.uid());

drop policy if exists "conversation participants can read messages" on public.messages;
create policy "conversation participants can read messages"
on public.messages for select
to authenticated
using (
  exists (
    select 1 from public.conversations
    where conversations.id = messages.conversation_id
      and (conversations.buyer_id = auth.uid() or conversations.owner_id = auth.uid())
  )
);

drop policy if exists "conversation participants can send messages" on public.messages;
create policy "conversation participants can send messages"
on public.messages for insert
to authenticated
with check (
  sender_id = auth.uid()
  and exists (
    select 1 from public.conversations
    where conversations.id = messages.conversation_id
      and (conversations.buyer_id = auth.uid() or conversations.owner_id = auth.uid())
  )
);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, email, phone)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'name', ''),
    coalesce(new.email, ''),
    coalesce(new.raw_user_meta_data ->> 'phone', '')
  )
  on conflict (id) do update
  set
    full_name = excluded.full_name,
    email = excluded.email,
    phone = excluded.phone,
    updated_at = now();

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute function public.handle_new_user();

-- Optional image storage. Run from Dashboard > Storage too:
-- Create public buckets named: property-images, profile-images, message-files.
-- Keep buckets public if you want to use getPublicUrl() directly in this app.

insert into storage.buckets (id, name, public)
values ('message-files', 'message-files', true)
on conflict (id) do nothing;

drop policy if exists "public can read property images" on storage.objects;
create policy "public can read property images"
on storage.objects for select
to public
using (bucket_id = 'property-images');

drop policy if exists "users can upload property images" on storage.objects;
create policy "users can upload property images"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'property-images'
);

drop policy if exists "users can update own property images" on storage.objects;
create policy "users can update own property images"
on storage.objects for update
to authenticated
using (
  bucket_id = 'property-images'
)
with check (
  bucket_id = 'property-images'
);

drop policy if exists "users can delete own property images" on storage.objects;
create policy "users can delete own property images"
on storage.objects for delete
to authenticated
using (
  bucket_id = 'property-images'
);

drop policy if exists "public can read profile images" on storage.objects;
create policy "public can read profile images"
on storage.objects for select
to public
using (bucket_id = 'profile-images');

drop policy if exists "users can upload profile images" on storage.objects;
create policy "users can upload profile images"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'profile-images'
  and (storage.foldername(name))[1] = auth.uid()::text
);

drop policy if exists "users can update own profile images" on storage.objects;
create policy "users can update own profile images"
on storage.objects for update
to authenticated
using (
  bucket_id = 'profile-images'
  and (storage.foldername(name))[1] = auth.uid()::text
)
with check (
  bucket_id = 'profile-images'
  and (storage.foldername(name))[1] = auth.uid()::text
);

drop policy if exists "users can delete own profile images" on storage.objects;
create policy "users can delete own profile images"
on storage.objects for delete
to authenticated
using (
  bucket_id = 'profile-images'
  and (storage.foldername(name))[1] = auth.uid()::text
);

drop policy if exists "public can read message files" on storage.objects;
create policy "public can read message files"
on storage.objects for select
to public
using (bucket_id = 'message-files');

drop policy if exists "users can upload message files" on storage.objects;
create policy "users can upload message files"
on storage.objects for insert
to authenticated
with check (
  bucket_id = 'message-files'
  and (storage.foldername(name))[1] = auth.uid()::text
);

-- Make one account superadmin after signing up:
-- update public.profiles set role = 'superadmin' where email = 'YOUR_EMAIL@example.com';

-- One-time cleanup for old posts created before API prediction integration.
-- Those rows copied the manually entered price into predicted_price.
update public.properties
set predicted_price = null
where predicted_price is not null
  and trim(predicted_price) = trim(price);

-- Refresh Supabase/PostgREST schema cache after table changes.
notify pgrst, 'reload schema';
