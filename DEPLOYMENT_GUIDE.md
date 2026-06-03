# Deployment Guide

## 1. Create Supabase tables
Open Supabase → SQL Editor → New Query.
Paste the contents of `supabase/schema.sql` and click Run.

## 2. Add environment variables locally
Create a file named `.env` in the project root:

```env
VITE_SUPABASE_URL=https://dhbpyokildgzzzrbqrgn.supabase.co
VITE_SUPABASE_ANON_KEY=your-anon-public-key
```

## 3. Run locally
```bash
npm install
npm run dev
```

Open `http://localhost:5173`.

## 4. Push to GitHub
Using GitHub Desktop or terminal, commit and push the updated project.

## 5. Deploy to Vercel
In Vercel:
- New Project
- Import your GitHub repo
- Add environment variables:
  - `VITE_SUPABASE_URL`
  - `VITE_SUPABASE_ANON_KEY`
- Deploy

## 6. Prototype limitations
Before using real patient data, add:
- Supabase Auth
- CHW/supervisor/investigator roles
- strict Row Level Security policies
- audit logs
- final IRB-approved consent wording
