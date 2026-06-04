-- Run this in Supabase SQL Editor
-- Adds UPDATE and DELETE policies for all tables (prototype — tighten with auth later)

do $$ begin execute 'create policy "prototype update communities" on communities for update using (true)'; exception when duplicate_object then null; end $$;
do $$ begin execute 'create policy "prototype delete communities" on communities for delete using (true)'; exception when duplicate_object then null; end $$;
do $$ begin execute 'create policy "prototype update chws" on chws for update using (true)'; exception when duplicate_object then null; end $$;
do $$ begin execute 'create policy "prototype delete chws" on chws for delete using (true)'; exception when duplicate_object then null; end $$;
do $$ begin execute 'create policy "prototype update participants" on participants for update using (true)'; exception when duplicate_object then null; end $$;
do $$ begin execute 'create policy "prototype delete participants" on participants for delete using (true)'; exception when duplicate_object then null; end $$;
do $$ begin execute 'create policy "prototype update baseline" on baseline_surveys for update using (true)'; exception when duplicate_object then null; end $$;
do $$ begin execute 'create policy "prototype delete baseline" on baseline_surveys for delete using (true)'; exception when duplicate_object then null; end $$;
do $$ begin execute 'create policy "prototype update visits" on biweekly_visits for update using (true)'; exception when duplicate_object then null; end $$;
do $$ begin execute 'create policy "prototype delete visits" on biweekly_visits for delete using (true)'; exception when duplicate_object then null; end $$;
do $$ begin execute 'create policy "prototype update endline" on endline_surveys for update using (true)'; exception when duplicate_object then null; end $$;
do $$ begin execute 'create policy "prototype delete endline" on endline_surveys for delete using (true)'; exception when duplicate_object then null; end $$;
do $$ begin execute 'create policy "prototype update chw surveys" on chw_surveys for update using (true)'; exception when duplicate_object then null; end $$;
do $$ begin execute 'create policy "prototype delete chw surveys" on chw_surveys for delete using (true)'; exception when duplicate_object then null; end $$;
do $$ begin execute 'create policy "prototype update supervisor surveys" on supervisor_surveys for update using (true)'; exception when duplicate_object then null; end $$;
do $$ begin execute 'create policy "prototype delete supervisor surveys" on supervisor_surveys for delete using (true)'; exception when duplicate_object then null; end $$;
