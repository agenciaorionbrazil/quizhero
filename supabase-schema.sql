create extension if not exists "pgcrypto";

create table if not exists leads (
  id uuid primary key default gen_random_uuid(),
  first_name text not null,
  whatsapp text not null,
  email text not null,
  profile text check (profile in ('male', 'female')),
  source text default 'hero_checkup',
  created_at timestamptz not null default now()
);

create table if not exists quiz_sessions (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid references leads(id) on delete set null,
  profile text check (profile in ('male', 'female')),
  status text not null default 'started',
  started_at timestamptz not null default now(),
  completed_at timestamptz
);

create table if not exists answers (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references quiz_sessions(id) on delete cascade,
  question_id text not null,
  question_text text not null,
  answer_text text not null,
  score numeric,
  tag text,
  created_at timestamptz not null default now()
);

create table if not exists scores (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references quiz_sessions(id) on delete cascade,
  overall_score numeric not null,
  energy_score numeric,
  body_composition_score numeric,
  strength_score numeric,
  recovery_score numeric,
  consistency_score numeric,
  body_confidence_score numeric,
  evolution_capacity_score numeric,
  classification text,
  created_at timestamptz not null default now()
);

create table if not exists diagnoses (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references quiz_sessions(id) on delete cascade,
  diagnosis jsonb not null,
  action_plan jsonb not null,
  ai_model text,
  created_at timestamptz not null default now()
);

create table if not exists tags (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid references leads(id) on delete cascade,
  session_id uuid references quiz_sessions(id) on delete cascade,
  tag text not null,
  created_at timestamptz not null default now()
);

create table if not exists conversion_events (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid references leads(id) on delete set null,
  session_id uuid references quiz_sessions(id) on delete set null,
  event_name text not null,
  event_payload jsonb,
  created_at timestamptz not null default now()
);

create table if not exists consent_records (
  id uuid primary key default gen_random_uuid(),
  lead_id uuid references leads(id) on delete cascade,
  consent_text text not null,
  consent_context jsonb,
  accepted_at timestamptz not null default now()
);
