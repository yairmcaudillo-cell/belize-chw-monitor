-- add_columns.sql
-- Run this in Supabase SQL Editor.
-- Adds created_by (audit trail) to all tables, and consent_date to participants.

-- created_by: tracks which authenticated user inserted the row
alter table communities        add column if not exists created_by uuid references auth.users(id);
alter table chws               add column if not exists created_by uuid references auth.users(id);
alter table participants       add column if not exists created_by uuid references auth.users(id);
alter table baseline_surveys   add column if not exists created_by uuid references auth.users(id);
alter table biweekly_visits    add column if not exists created_by uuid references auth.users(id);
alter table endline_surveys    add column if not exists created_by uuid references auth.users(id);
alter table chw_surveys        add column if not exists created_by uuid references auth.users(id);
alter table supervisor_surveys add column if not exists created_by uuid references auth.users(id);

-- consent_date: date consent form was signed (distinct from consent_completed boolean)
alter table participants add column if not exists consent_date date;
