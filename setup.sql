-- =============================================================
-- 다윈 실시간 투표 도구 · Supabase 초기 설정 (1회만 실행)
-- Supabase 대시보드 → SQL Editor → New query → 전체 붙여넣기 → Run
-- 여러 번 실행해도 오류 없이 같은 결과가 나오도록 작성했습니다.
-- =============================================================

-- 1) 방(세션) 상태: 강사 화면이 현재 질문·마감 여부 등을 저장
create table if not exists public.poll_rooms (
  code        text primary key,
  state       jsonb not null default '{}'::jsonb,
  updated_at  timestamptz not null default now()
);

-- 2) 참가자 응답
create table if not exists public.poll_answers (
  id          bigint generated always as identity primary key,
  room        text not null,
  qid         text not null,
  value       text not null check (char_length(value) <= 600),
  cid         text,
  created_at  timestamptz not null default now()
);
create index if not exists poll_answers_room_qid_idx
  on public.poll_answers (room, qid, created_at);

-- 3) 보안(RLS): 로그인 없는 익명 참가자가 읽기·쓰기 가능하도록 허용
alter table public.poll_rooms   enable row level security;
alter table public.poll_answers enable row level security;

drop policy if exists "rooms_all"   on public.poll_rooms;
drop policy if exists "answers_sel" on public.poll_answers;
drop policy if exists "answers_ins" on public.poll_answers;
drop policy if exists "answers_del" on public.poll_answers;

create policy "rooms_all"   on public.poll_rooms   for all    to anon, authenticated using (true) with check (true);
create policy "answers_sel" on public.poll_answers for select to anon, authenticated using (true);
create policy "answers_ins" on public.poll_answers for insert to anon, authenticated with check (true);
create policy "answers_del" on public.poll_answers for delete to anon, authenticated using (true);

grant select, insert, update, delete on public.poll_rooms   to anon, authenticated;
grant select, insert, delete         on public.poll_answers to anon, authenticated;

-- 4) 실시간(Realtime): 새 응답이 들어오면 강사 화면에 즉시 반영
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
    where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'poll_answers'
  ) then
    alter publication supabase_realtime add table public.poll_answers;
  end if;
end $$;

-- 확인용: 아래 결과에 poll_rooms, poll_answers 두 줄이 보이면 성공
select table_name from information_schema.tables
where table_schema = 'public' and table_name in ('poll_rooms','poll_answers');
