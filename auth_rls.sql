-- auth_rls.sql
-- Run this AFTER auth_schema.sql to replace permissive prototype policies
-- with role-aware ones tied to Supabase Auth.
--
-- Roles: 'admin' (full access), 'supervisor' (read all, write all),
--        'chw' (own patients only, cannot delete)

-- ── Helper functions (security definer avoids recursion in profiles RLS) ──
create or replace function get_my_role() returns text
  language sql security definer stable
  as $$ select role from profiles where id = auth.uid() $$;

create or replace function get_my_chw_code() returns text
  language sql security definer stable
  as $$ select chw_code from profiles where id = auth.uid() $$;

-- ── profiles: fix the self-referencing supervisor policy ─────────────────
drop policy if exists "supervisors read all profiles" on profiles;
drop policy if exists "auth read profiles" on profiles;
create policy "auth read profiles" on profiles
  for select using (auth.uid() = id or get_my_role() in ('supervisor','admin'));

-- ── participants ──────────────────────────────────────────────────────────
drop policy if exists "prototype read participants" on participants;
drop policy if exists "prototype write participants" on participants;
drop policy if exists "prototype update participants" on participants;
drop policy if exists "prototype delete participants" on participants;

create policy "participants select" on participants for select using (
  get_my_role() in ('supervisor','admin') or get_my_chw_code() = chw_code
);
create policy "participants insert" on participants for insert with check (
  auth.uid() is not null and
  (get_my_role() in ('supervisor','admin') or get_my_chw_code() = chw_code)
);
create policy "participants update" on participants for update using (
  get_my_role() in ('supervisor','admin') or get_my_chw_code() = chw_code
);
create policy "participants delete" on participants for delete using (
  get_my_role() in ('supervisor','admin')
);

-- ── biweekly_visits ───────────────────────────────────────────────────────
drop policy if exists "prototype read visits" on biweekly_visits;
drop policy if exists "prototype write visits" on biweekly_visits;
drop policy if exists "prototype update visits" on biweekly_visits;
drop policy if exists "prototype delete visits" on biweekly_visits;

create policy "visits select" on biweekly_visits for select using (
  get_my_role() in ('supervisor','admin') or get_my_chw_code() = chw_code
);
create policy "visits insert" on biweekly_visits for insert with check (
  auth.uid() is not null and
  (get_my_role() in ('supervisor','admin') or get_my_chw_code() = chw_code)
);
create policy "visits update" on biweekly_visits for update using (
  get_my_role() in ('supervisor','admin') or get_my_chw_code() = chw_code
);
create policy "visits delete" on biweekly_visits for delete using (
  get_my_role() in ('supervisor','admin')
);

-- ── baseline_surveys (no chw_code column — join through participants) ─────
drop policy if exists "prototype read baseline" on baseline_surveys;
drop policy if exists "prototype write baseline" on baseline_surveys;
drop policy if exists "prototype update baseline" on baseline_surveys;
drop policy if exists "prototype delete baseline" on baseline_surveys;

create policy "baseline select" on baseline_surveys for select using (
  get_my_role() in ('supervisor','admin') or
  exists (select 1 from participants where study_id = baseline_surveys.study_id and chw_code = get_my_chw_code())
);
create policy "baseline insert" on baseline_surveys for insert with check (
  auth.uid() is not null and (
    get_my_role() in ('supervisor','admin') or
    exists (select 1 from participants where study_id = baseline_surveys.study_id and chw_code = get_my_chw_code())
  )
);
create policy "baseline update" on baseline_surveys for update using (
  get_my_role() in ('supervisor','admin') or
  exists (select 1 from participants where study_id = baseline_surveys.study_id and chw_code = get_my_chw_code())
);
create policy "baseline delete" on baseline_surveys for delete using (
  get_my_role() in ('supervisor','admin')
);

-- ── endline_surveys ────────────────────────────────────────────────────────
drop policy if exists "prototype read endline" on endline_surveys;
drop policy if exists "prototype write endline" on endline_surveys;
drop policy if exists "prototype update endline" on endline_surveys;
drop policy if exists "prototype delete endline" on endline_surveys;

create policy "endline select" on endline_surveys for select using (
  get_my_role() in ('supervisor','admin') or
  exists (select 1 from participants where study_id = endline_surveys.study_id and chw_code = get_my_chw_code())
);
create policy "endline insert" on endline_surveys for insert with check (
  auth.uid() is not null and (
    get_my_role() in ('supervisor','admin') or
    exists (select 1 from participants where study_id = endline_surveys.study_id and chw_code = get_my_chw_code())
  )
);
create policy "endline update" on endline_surveys for update using (
  get_my_role() in ('supervisor','admin') or
  exists (select 1 from participants where study_id = endline_surveys.study_id and chw_code = get_my_chw_code())
);
create policy "endline delete" on endline_surveys for delete using (
  get_my_role() in ('supervisor','admin')
);

-- ── communities & chws: all authenticated users can read, only admin/supervisor can write ──
drop policy if exists "prototype read communities" on communities;
drop policy if exists "prototype write communities" on communities;
drop policy if exists "prototype update communities" on communities;
drop policy if exists "prototype delete communities" on communities;
create policy "communities select" on communities for select using (auth.uid() is not null);
create policy "communities write"  on communities for all   using (get_my_role() in ('supervisor','admin'));

drop policy if exists "prototype read chws" on chws;
drop policy if exists "prototype write chws" on chws;
drop policy if exists "prototype update chws" on chws;
drop policy if exists "prototype delete chws" on chws;
create policy "chws select" on chws for select using (auth.uid() is not null);
create policy "chws write"  on chws for all   using (get_my_role() in ('supervisor','admin'));

-- ── chw_surveys: CHWs see own, supervisors/admins see all ─────────────────
drop policy if exists "prototype read chw surveys" on chw_surveys;
drop policy if exists "prototype write chw surveys" on chw_surveys;
drop policy if exists "prototype update chw surveys" on chw_surveys;
drop policy if exists "prototype delete chw surveys" on chw_surveys;
create policy "chw surveys select" on chw_surveys for select using (
  get_my_role() in ('supervisor','admin') or get_my_chw_code() = chw_code
);
create policy "chw surveys insert" on chw_surveys for insert with check (auth.uid() is not null);
create policy "chw surveys update" on chw_surveys for update using (
  get_my_role() in ('supervisor','admin') or get_my_chw_code() = chw_code
);

-- ── supervisor_surveys: supervisor and admin only ──────────────────────────
drop policy if exists "prototype read supervisor surveys" on supervisor_surveys;
drop policy if exists "prototype write supervisor surveys" on supervisor_surveys;
drop policy if exists "prototype update supervisor surveys" on supervisor_surveys;
drop policy if exists "prototype delete supervisor surveys" on supervisor_surveys;
create policy "supervisor surveys select" on supervisor_surveys for select using (
  get_my_role() in ('supervisor','admin')
);
create policy "supervisor surveys insert" on supervisor_surveys for insert with check (
  get_my_role() in ('supervisor','admin')
);
create policy "supervisor surveys update" on supervisor_surveys for update using (
  get_my_role() in ('supervisor','admin')
);
