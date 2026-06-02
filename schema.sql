-- Belize CHW Monitor V2 database schema
-- Run this in Supabase SQL Editor.

create table if not exists communities (
  id uuid primary key default gen_random_uuid(),
  name text unique not null,
  country text default 'Belize',
  active boolean default true,
  created_at timestamptz default now()
);

create table if not exists chws (
  id uuid primary key default gen_random_uuid(),
  chw_code text unique not null,
  name text not null,
  phone text,
  community text not null,
  training_completed boolean default false,
  active boolean default true,
  created_at timestamptz default now()
);

create table if not exists participants (
  id uuid primary key default gen_random_uuid(),
  study_id text unique not null,
  community text not null,
  chw_code text not null,
  condition text not null,
  enrollment_date date,
  age int,
  sex text,
  primary_language text,
  education_level text,
  occupation text,
  household_size int,
  status text default 'active',
  consent_completed boolean default false,
  created_at timestamptz default now()
);

create table if not exists baseline_surveys (
  id uuid primary key default gen_random_uuid(),
  study_id text not null,
  survey_date date not null,
  diabetes_type text,
  diabetes_year_diagnosed int,
  hypertension_diagnosed boolean,
  hypertension_year_diagnosed int,
  current_medications text,
  insulin_use boolean,
  prior_diabetes_education boolean,
  hospitalization_past_year boolean,
  emergency_visit_past_year boolean,
  a1c numeric,
  weight_kg numeric,
  waist_cm numeric,
  systolic_1 int,
  diastolic_1 int,
  systolic_2 int,
  diastolic_2 int,
  glucose_mg_dl numeric,
  glucose_context text,
  missed_meds_30_days text,
  med_barriers text,
  fruits_vegetables_days int,
  sugary_drinks_days int,
  processed_food_days int,
  large_portions_days int,
  healthy_eating_barrier text,
  active_days_per_week int,
  active_minutes_per_day int,
  activity_type text,
  activity_barriers text,
  knowledge_high_sugar_organs boolean,
  knowledge_exercise_helps boolean,
  knowledge_bp_complications boolean,
  knowledge_missing_meds_worse boolean,
  knowledge_healthy_eating_helps boolean,
  confidence_medications int,
  confidence_healthy_eating int,
  confidence_exercise int,
  confidence_symptoms int,
  confidence_seek_care int,
  food_worry boolean,
  skipped_meals boolean,
  could_not_afford_healthy_food boolean,
  could_not_afford_meds boolean,
  overall_health text,
  notes text,
  created_at timestamptz default now()
);

create table if not exists biweekly_visits (
  id uuid primary key default gen_random_uuid(),
  study_id text not null,
  chw_code text not null,
  visit_date date not null,
  visit_number int not null,
  weight_kg numeric,
  waist_cm numeric,
  bp1_sys int,
  bp1_dia int,
  bp2_sys int,
  bp2_dia int,
  glucose_mg_dl numeric,
  glucose_context text,
  med_adherence text,
  med_barriers text,
  fruits_vegetables text,
  sugary_processed text,
  large_portions text,
  healthy_eating_barriers text,
  physical_activity text,
  activity_types text,
  activity_barriers text,
  confidence_diabetes int,
  observations text,
  referred boolean default false,
  referral_reason text,
  booklet_number text,
  booklet_usefulness int,
  education_comments text,
  chw_notes text,
  sync_status text default 'synced',
  created_at timestamptz default now()
);

create table if not exists endline_surveys (
  id uuid primary key default gen_random_uuid(),
  study_id text not null,
  survey_date date not null,
  a1c numeric,
  weight_kg numeric,
  waist_cm numeric,
  systolic_1 int,
  diastolic_1 int,
  systolic_2 int,
  diastolic_2 int,
  glucose_mg_dl numeric,
  med_adherence text,
  fruits_vegetables_days int,
  sugary_drinks_days int,
  processed_food_days int,
  active_days_per_week int,
  knowledge_high_sugar_organs boolean,
  knowledge_exercise_helps boolean,
  knowledge_bp_complications boolean,
  knowledge_missing_meds_worse boolean,
  knowledge_healthy_eating_helps boolean,
  confidence_medications int,
  confidence_healthy_eating int,
  confidence_exercise int,
  confidence_symptoms int,
  confidence_seek_care int,
  program_helpfulness int,
  chw_visit_helpfulness int,
  education_materials_helpfulness int,
  app_workflow_satisfaction int,
  recommend_program boolean,
  improved_understanding boolean,
  helped_control_diabetes boolean,
  helped_control_bp boolean,
  most_helpful_part text,
  suggested_changes text,
  notes text,
  created_at timestamptz default now()
);

create table if not exists chw_surveys (
  id uuid primary key default gen_random_uuid(),
  chw_code text not null,
  survey_date date not null,
  quarter text,
  app_ease_of_use int,
  visit_time_minutes int,
  technical_issues text,
  internet_issues text,
  most_useful_feature text,
  least_useful_feature text,
  continue_using boolean,
  notes text,
  created_at timestamptz default now()
);

create table if not exists supervisor_surveys (
  id uuid primary key default gen_random_uuid(),
  supervisor_name text,
  survey_date date not null,
  period text,
  reduced_manual_workload int,
  improved_monitoring int,
  improved_data_quality int,
  improved_reporting int,
  technical_concerns text,
  recommended_changes text,
  notes text,
  created_at timestamptz default now()
);

-- For early prototype only: permissive RLS. Tighten before real patient data.
alter table communities enable row level security;
alter table chws enable row level security;
alter table participants enable row level security;
alter table baseline_surveys enable row level security;
alter table biweekly_visits enable row level security;
alter table endline_surveys enable row level security;
alter table chw_surveys enable row level security;
alter table supervisor_surveys enable row level security;

do $$
begin
  execute 'create policy "prototype read communities" on communities for select using (true)';
exception when duplicate_object then null; end $$;
do $$
begin
  execute 'create policy "prototype write communities" on communities for insert with check (true)';
exception when duplicate_object then null; end $$;
do $$
begin
  execute 'create policy "prototype read chws" on chws for select using (true)';
exception when duplicate_object then null; end $$;
do $$
begin
  execute 'create policy "prototype write chws" on chws for insert with check (true)';
exception when duplicate_object then null; end $$;
do $$
begin
  execute 'create policy "prototype read participants" on participants for select using (true)';
exception when duplicate_object then null; end $$;
do $$
begin
  execute 'create policy "prototype write participants" on participants for insert with check (true)';
exception when duplicate_object then null; end $$;
do $$
begin
  execute 'create policy "prototype read baseline" on baseline_surveys for select using (true)';
exception when duplicate_object then null; end $$;
do $$
begin
  execute 'create policy "prototype write baseline" on baseline_surveys for insert with check (true)';
exception when duplicate_object then null; end $$;
do $$
begin
  execute 'create policy "prototype read visits" on biweekly_visits for select using (true)';
exception when duplicate_object then null; end $$;
do $$
begin
  execute 'create policy "prototype write visits" on biweekly_visits for insert with check (true)';
exception when duplicate_object then null; end $$;
do $$
begin
  execute 'create policy "prototype read endline" on endline_surveys for select using (true)';
exception when duplicate_object then null; end $$;
do $$
begin
  execute 'create policy "prototype write endline" on endline_surveys for insert with check (true)';
exception when duplicate_object then null; end $$;
do $$
begin
  execute 'create policy "prototype read chw surveys" on chw_surveys for select using (true)';
exception when duplicate_object then null; end $$;
do $$
begin
  execute 'create policy "prototype write chw surveys" on chw_surveys for insert with check (true)';
exception when duplicate_object then null; end $$;
do $$
begin
  execute 'create policy "prototype read supervisor surveys" on supervisor_surveys for select using (true)';
exception when duplicate_object then null; end $$;
do $$
begin
  execute 'create policy "prototype write supervisor surveys" on supervisor_surveys for insert with check (true)';
exception when duplicate_object then null; end $$;

insert into communities (name) values ('Sarteneja'), ('Community 2') on conflict (name) do nothing;
insert into chws (chw_code, name, community, training_completed) values
('CHW-001','Maria','Sarteneja',true),
('CHW-002','Ana','Sarteneja',true),
('CHW-003','Rosa','Community 2',false)
on conflict (chw_code) do nothing;
insert into participants (study_id, community, chw_code, condition, enrollment_date, age, sex, primary_language, consent_completed) values
('SAR-001','Sarteneja','CHW-001','Diabetes + Hypertension', current_date, 58, 'Female', 'Spanish', true),
('SAR-002','Sarteneja','CHW-001','Diabetes', current_date, 63, 'Male', 'Spanish', true),
('SAR-003','Sarteneja','CHW-002','Hypertension', current_date, 49, 'Female', 'Spanish', true)
on conflict (study_id) do nothing;
