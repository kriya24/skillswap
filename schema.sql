-- Paste this whole file into Supabase > SQL Editor > Run.

create table profiles (
  id uuid primary key references auth.users on delete cascade,
  name text not null,
  city text,
  created_at timestamptz default now()
);

create table skills (
  id bigint generated always as identity primary key,
  user_id uuid not null default auth.uid() references profiles(id) on delete cascade,
  name text not null,
  kind text not null check (kind in ('teach', 'learn')),
  unique (user_id, name, kind)
);

-- Row Level Security: anyone signed in can read; you can only change your own rows.
alter table profiles enable row level security;
alter table skills enable row level security;

create policy "read profiles" on profiles for select to authenticated using (true);
create policy "insert own profile" on profiles for insert to authenticated with check (id = auth.uid());
create policy "update own profile" on profiles for update to authenticated using (id = auth.uid());

create policy "read skills" on skills for select to authenticated using (true);
create policy "insert own skills" on skills for insert to authenticated with check (user_id = auth.uid());
create policy "delete own skills" on skills for delete to authenticated using (user_id = auth.uid());

-- Matching: people who teach what I want to learn, or want to learn what I teach.
create or replace function find_matches()
returns table (uid uuid, pname text, pcity text, they_teach text[], they_learn text[])
language sql stable as $$
  with me as (select lower(name) as n, kind from skills where user_id = auth.uid())
  select p.id, p.name, p.city,
    coalesce(array_agg(distinct s.name) filter (
      where s.kind = 'teach' and lower(s.name) in (select n from me where kind = 'learn')), '{}'),
    coalesce(array_agg(distinct s.name) filter (
      where s.kind = 'learn' and lower(s.name) in (select n from me where kind = 'teach')), '{}')
  from profiles p join skills s on s.user_id = p.id
  where p.id <> auth.uid()
  group by p.id
  having count(*) filter (where
    (s.kind = 'teach' and lower(s.name) in (select n from me where kind = 'learn')) or
    (s.kind = 'learn' and lower(s.name) in (select n from me where kind = 'teach'))) > 0;
$$;
