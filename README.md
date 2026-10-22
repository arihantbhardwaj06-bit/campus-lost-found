# Campus Lost & Found

The application uses a shared Supabase PostgreSQL table for reports. The browser loads and posts reports through Supabase's Data API, while Postgres row-level security controls public access. The existing feed, search, form, and toast interaction remain in place.

## Database and access model

This setup is for a public campus board without student accounts. Any visitor can read reports and post a report; visitors cannot edit or delete reports. The form collects no names, email addresses, or other account details. Because posts are public and anonymous, this is suitable for a low-stakes community board, not private or sensitive reports. Add Supabase Auth and ownership-based RLS before supporting private reports, author controls, or abuse-resistant posting.

Run [`supabase/schema.sql`](supabase/schema.sql) in the SQL Editor of your Supabase project. It creates the table, input length constraints, index, grants, and RLS policies. Reports are currently limited to the newest 100 in the feed, and the app refreshes the shared feed every 30 seconds.

## Create the Supabase project

1. Create a Supabase account and a project on the Free plan. Choose the region closest to campus and save the database password somewhere secure.
2. In the project dashboard, open **SQL Editor**, paste `supabase/schema.sql`, and run it.
3. Open **Project Settings → API Keys**. Copy the Project URL and the `publishable` key. This key is intended to be used in browser apps; the table grants and RLS policies restrict what it can do.
4. Do not put a `secret` key, database password, or any other secret in this app or in a `VITE_` variable. Vite embeds `VITE_` values into the public browser bundle.

The Free plan is useful for a small campus pilot; review current quotas, inactivity behavior, backups, and pricing on Supabase before relying on it for an ongoing service. Current details are on [Supabase's plan and billing docs](https://supabase.com/docs/guides/platform/billing-on-supabase) and [pricing page](https://supabase.com/pricing).

## Local development

Requires Node.js 18+ and npm.

Set these values in the ignored `.env` file at the project root. The project URL is already filled in for your Supabase project; add your publishable key locally:

| Variable | Value |
| --- | --- |
| `VITE_SUPABASE_URL` | Project URL from Supabase API settings |
| `VITE_SUPABASE_PUBLISHABLE_KEY` | Publishable key from Supabase API Keys settings |

Then run `npm install` once, followed by `npm run dev` for local development or `npm run build` to create `dist/`.

## Deploy with Vercel

1. Push this project to a Git repository and import it into Vercel.
2. In the Vercel project settings, add `VITE_SUPABASE_URL` and `VITE_SUPABASE_PUBLISHABLE_KEY` under **Settings → Environment Variables** for Production (and Preview if needed).
3. Deploy. The included `vercel.json` sets the build command to `npm run build` and output directory to `dist`.
4. Open the deployed site and verify reports can be loaded and posted. Vercel variables are applied at build time, so trigger a new deployment after changing them.

The project must exist and its SQL setup must be complete before the deployed app can connect. Free-tier availability and limits can change; confirm current terms with both providers before launch.
