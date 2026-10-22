-- Run this once in the Supabase SQL Editor for the project.
create table if not exists public.lost_items (
  id bigint generated always as identity primary key,
  name text not null check (char_length(btrim(name)) between 1 and 60),
  description text not null check (char_length(btrim(description)) between 1 and 300),
  location text not null check (char_length(btrim(location)) between 1 and 80),
  created_at timestamptz not null default now()
);

create index if not exists lost_items_created_at_idx
  on public.lost_items (created_at desc);

alter table public.lost_items enable row level security;
revoke all on table public.lost_items from anon, authenticated;
grant select, insert on table public.lost_items to anon;

drop policy if exists "Anyone can read lost item reports" on public.lost_items;
create policy "Anyone can read lost item reports"
  on public.lost_items for select to anon using (true);

drop policy if exists "Anyone can post lost item reports" on public.lost_items;
create policy "Anyone can post lost item reports"
  on public.lost_items for insert to anon with check (true);

-- No update or delete grants/policies are provided to public visitors.
