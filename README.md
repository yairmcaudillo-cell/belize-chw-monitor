# Belize CHW Monitor V2

Pilot-ready prototype for a community health worker diabetes/hypertension monitoring project in Belize.

## Includes
- Supabase database integration
- Offline local queue fallback
- Participant enrollment
- Baseline survey v1
- Biweekly visit form
- Endline / 12-month survey v1
- CHW usability survey
- Supervisor implementation survey
- Dashboard and research exports
- Draft Kobo/ODK form files

## Local setup
1. Copy `.env.example` to `.env`
2. Paste your Supabase anon public key into `.env`
3. Run:

```bash
npm install
npm run dev
```

## Supabase setup
Run `supabase/schema.sql` in Supabase SQL Editor.

## Safety
The current RLS policies are permissive for prototype testing only. Do not use real patient data until authentication and role-based policies are added.
