-- Ejecutar en SQL Editor de un proyecto Supabase dedicado al juego.
begin;
create schema if not exists elite_private;
revoke all on schema elite_private from public, anon, authenticated;
create table if not exists elite_private.players (
  id uuid primary key references auth.users(id) on delete cascade,
  nickname text not null check (char_length(nickname) between 1 and 60),
  created_at timestamptz not null default now(),
  last_seen timestamptz not null default now(),
  prefs jsonb not null default '{}'::jsonb,
  saved_game jsonb,
  total_seconds bigint not null default 0
);
create table if not exists elite_private.results (
  player_id uuid not null references elite_private.players(id) on delete cascade,
  game_id text not null check(char_length(game_id) between 1 and 100),
  mode text not null check(mode in ('penalty','target','juggle')),
  score int not null check(score between 0 and 1000000),
  touches int not null check(touches between 0 and 10000),
  seconds int not null check(seconds between 0 and 10800),
  attempt int not null check(attempt between 0 and 5),
  miss int not null check(miss between 0 and 3),
  saves int not null check(saves between 0 and 5),
  outs int not null check(outs between 0 and 5),
  played_at timestamptz not null default clock_timestamp(),
  primary key(player_id,game_id)
);
alter table elite_private.players enable row level security;
alter table elite_private.results enable row level security;
create or replace function elite_private.schedule_at(t timestamptz)
returns jsonb language sql stable set search_path = '' as $$
with local_day as (select (t at time zone 'Europe/Madrid')::date d),
days as (select d + n as d from local_day cross join generate_series(0,8) n),
windows as (
 select (d + time '18:00') at time zone 'Europe/Madrid' as opens, (d + time '21:00') at time zone 'Europe/Madrid' as closes from days
 union all
 select (d + time '07:00') at time zone 'Europe/Madrid', (d + time '11:00') at time zone 'Europe/Madrid' from days where extract(isodow from d) in (6,7)
)
select jsonb_build_object('server_now',t,'open',exists(select 1 from windows where t>=opens and t<closes),
'next_change',coalesce((select closes from windows where t>=opens and t<closes limit 1),(select min(opens) from windows where opens>t)),'timezone','Europe/Madrid');
$$;
create or replace function public.elite_status() returns jsonb language sql security definer set search_path = '' as $$ select elite_private.schedule_at(clock_timestamp()) $$;
create or replace function public.elite_signup_hook(event jsonb) returns jsonb language plpgsql security definer set search_path = '' as $$
begin
 if coalesce(event#>>'{user,app_metadata,provider}',event#>>'{user,raw_app_meta_data,provider}','') <> 'google' then
  return jsonb_build_object('error',jsonb_build_object('http_code',403,'message','Registro exclusivamente mediante Google.'));
 end if;
 if not (elite_private.schedule_at(clock_timestamp())->>'open')::boolean then
  return jsonb_build_object('error',jsonb_build_object('http_code',403,'message','Registro cerrado. Consulta el horario del juego.'));
 end if;
 return '{}'::jsonb;
end $$;
create or replace function elite_private.require_player() returns uuid language plpgsql security definer set search_path = '' as $$
declare u uuid := auth.uid();
begin
 if u is null or not exists(select 1 from auth.identities where user_id=u and provider='google') then raise exception 'Acceso Google obligatorio' using errcode='42501'; end if;
 if not (elite_private.schedule_at(clock_timestamp())->>'open')::boolean then raise exception 'Juego cerrado' using errcode='42501'; end if;
 return u;
end $$;
create or replace function public.elite_profile() returns jsonb language plpgsql security definer set search_path = '' as $$
declare u uuid := elite_private.require_player(); p elite_private.players%rowtype; r jsonb;
begin
 insert into elite_private.players(id,nickname) select u,left(coalesce(nullif(raw_user_meta_data->>'full_name',''),nullif(raw_user_meta_data->>'name',''),'Jugador'),60) from auth.users where id=u on conflict(id) do update set last_seen=clock_timestamp();
 select * into p from elite_private.players where id=u;
 select coalesce(jsonb_agg(jsonb_build_object('id',game_id,'mode',mode,'score',score,'touches',touches,'seconds',seconds,'attempt',attempt,'miss',miss,'saves',saves,'outs',outs,'day',to_char(played_at at time zone 'Europe/Madrid','YYYY-MM-DD'),'at',floor(extract(epoch from played_at)*1000)) order by played_at desc),'[]'::jsonb) into r from (select * from elite_private.results where player_id=u order by played_at desc limit 2000) q;
 return jsonb_build_object('id',p.id,'nickname',p.nickname,'created_at',p.created_at,'last_seen',p.last_seen,'prefs',p.prefs,'saved_game',p.saved_game,'total_seconds',p.total_seconds,'history',r,'records',(select jsonb_build_object('penalty',coalesce(max(score) filter(where mode='penalty'),0),'target',coalesce(max(score) filter(where mode='target'),0),'juggle',coalesce(max(score) filter(where mode='juggle'),0),'touches',coalesce(max(touches) filter(where mode='juggle'),0),'games',count(*)) from elite_private.results where player_id=u));
end $$;
create or replace function public.elite_save(p_prefs jsonb,p_save jsonb,p_nickname text default null) returns boolean language plpgsql security definer set search_path = '' as $$
declare u uuid:=elite_private.require_player();
begin
 if p_prefs is null or jsonb_typeof(p_prefs)<>'object' or pg_column_size(p_prefs)>8192 or (p_save is not null and (jsonb_typeof(p_save)<>'object' or pg_column_size(p_save)>32768)) then raise exception 'Datos inválidos'; end if;
 if p_nickname is not null and char_length(btrim(p_nickname)) not between 1 and 60 then raise exception 'Nombre inválido'; end if;
 update elite_private.players set prefs=p_prefs,saved_game=p_save,nickname=coalesce(btrim(p_nickname),nickname),last_seen=clock_timestamp() where id=u;
 if not found then raise exception 'Ficha no inicializada'; end if;
 return true;
end $$;
create or replace function public.elite_result(p_result jsonb) returns boolean language plpgsql security definer set search_path = '' as $$
declare u uuid:=elite_private.require_player(); m text:=p_result->>'mode'; s int:=(p_result->>'score')::int; n int:=coalesce((p_result->>'touches')::int,0); dur int:=coalesce((p_result->>'seconds')::int,0); ins int;
begin
 if m not in ('penalty','target','juggle') or s is null or s<0 or n<0 or (m='penalty' and (s>5 or n<>0)) or (m='target' and (s>500 or n<>0)) or (m='juggle' and s>n*75+(n/5)*100) then raise exception 'Resultado inválido'; end if;
 insert into elite_private.results(player_id,game_id,mode,score,touches,seconds,attempt,miss,saves,outs) values(u,p_result->>'id',m,s,n,dur,coalesce((p_result->>'attempt')::int,0),coalesce((p_result->>'miss')::int,0),coalesce((p_result->>'saves')::int,0),coalesce((p_result->>'outs')::int,0)) on conflict do nothing;
 get diagnostics ins=row_count;
 if ins>0 then update elite_private.players set total_seconds=total_seconds+dur,last_seen=clock_timestamp() where id=u; end if;
 return ins>0;
end $$;
create or replace function public.elite_heartbeat() returns jsonb language plpgsql security definer set search_path = '' as $$
begin
 perform elite_private.require_player();
 return elite_private.schedule_at(clock_timestamp());
end $$;
revoke all on function public.elite_heartbeat() from public,anon,authenticated;
grant execute on function public.elite_heartbeat() to authenticated;
revoke all on function public.elite_status() from public,anon,authenticated;
grant execute on function public.elite_status() to anon,authenticated;
revoke all on function public.elite_signup_hook(jsonb) from public,anon,authenticated;
grant execute on function public.elite_signup_hook(jsonb) to supabase_auth_admin;
revoke all on function public.elite_profile(),public.elite_save(jsonb,jsonb,text),public.elite_result(jsonb) from public,anon,authenticated;
grant execute on function public.elite_profile(),public.elite_save(jsonb,jsonb,text),public.elite_result(jsonb) to authenticated;
commit;
