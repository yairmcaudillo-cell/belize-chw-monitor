-- Run this in Supabase SQL Editor AFTER schema.sql
-- Creates the profiles table that links auth users to roles

create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  role text not null check (role in ('chw','supervisor','admin')),
  chw_code text,          -- required for role='chw', null for others
  name text not null,
  created_at timestamptz default now()
);

alter table profiles enable row level security;

-- Any authenticated user can read their own profile
create policy "read own profile" on profiles
  for select using (auth.uid() = id);

-- Supervisors and admins can read all profiles
create policy "supervisors read all profiles" on profiles
  for select using (
    exists (select 1 from profiles where id = auth.uid() and role in ('supervisor','admin'))
  );

-- Only admins can insert/update profiles (managed via Supabase dashboard for now)
create policy "admins write profiles" on profiles
  for all using (
    exists (select 1 from profiles where id = auth.uid() and role = 'admin')
  );

-- ─────────────────────────────────────────────────────────────
-- HOW TO CREATE YOUR FIRST USERS
-- ─────────────────────────────────────────────────────────────
-- 1. Go to Supabase Dashboard → Authentication → Users → Add user
-- 2. Create the user with email + password
-- 3. Copy the user's UUID from the Users list
-- 4. Run this INSERT (replace the UUID and details):
--
-- insert into profiles (id, role, chw_code, name) values
--   ('paste-uuid-here', 'admin', null, 'Supervisor Name');
--
-- For a CHW:
-- insert into profiles (id, role, chw_code, name) values
--   ('paste-uuid-here', 'chw', 'CHW-001', 'Maria');
--
-- Roles: 'admin' (full access), 'supervisor' (read all, write all), 'chw' (own patients only)
-- ─────────────────────────────────────────────────────────────
