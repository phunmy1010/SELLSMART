-- Run this in your Supabase SQL editor

-- Sales table
create table if not exists sales (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade,
  product_name text not null,
  quantity integer not null,
  unit_price numeric not null,
  unit_cost numeric default 0,
  total numeric not null,
  date date not null,
  created_at timestamptz default now()
);

-- Expenses table
create table if not exists expenses (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade,
  description text not null,
  amount numeric not null,
  category text not null,
  date date not null,
  created_at timestamptz default now()
);

-- Inventory table
create table if not exists inventory (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade,
  name text not null,
  quantity integer not null,
  unit_cost numeric not null,
  min_stock integer default 5,
  created_at timestamptz default now()
);

-- Debts table
create table if not exists debts (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade,
  customer_name text not null,
  total_amount numeric not null,
  paid_amount numeric default 0,
  due_date date,
  status text default 'pending',
  notes text,
  payments jsonb default '[]',
  created_at timestamptz default now()
);

-- Circles table
create table if not exists circles (
  id text primary key,
  user_id uuid references auth.users(id) on delete cascade,
  name text not null,
  contribution_amount numeric not null,
  admin_fee numeric default 500,
  member_count integer not null,
  start_month text not null,
  deadline_day integer default 25,
  description text,
  invite_code text unique not null,
  members jsonb default '[]',
  created_at timestamptz default now()
);

-- Row Level Security
alter table sales enable row level security;
alter table expenses enable row level security;
alter table inventory enable row level security;
alter table debts enable row level security;
alter table circles enable row level security;

-- Policies
create policy "Users manage own sales" on sales for all using (auth.uid() = user_id);
create policy "Users manage own expenses" on expenses for all using (auth.uid() = user_id);
create policy "Users manage own inventory" on inventory for all using (auth.uid() = user_id);
create policy "Users manage own debts" on debts for all using (auth.uid() = user_id);
create policy "Users manage own circles" on circles for all using (auth.uid() = user_id);
