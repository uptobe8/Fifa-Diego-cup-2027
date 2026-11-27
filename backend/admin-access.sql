-- V15: ejecutar después de setup.sql. No contiene contraseñas.
begin;
create table if not exists elite_private.administrators (
  id uuid primary key references auth.users(id) on delete cascade
);
alter table elite_private.administrators enable row level security;
revoke all on elite_private.administrators from public,anon,authenticated;
create or replace function elite_private.is_admin(u uuid) returns boolean
language sql stable security definer set search_path = '' as $$
 select exists(select 1 from elite_private.administrators where id=u)
 and coalesce(auth.jwt()->'amr','[]'::jsonb) @> '[{"method":"password"}]'::jsonb;
$$;
revoke all on function elite_private.is_admin(uuid) from public,anon,authenticated;
create or replace function elite_private.require_player() returns uuid language plpgsql security definer set search_path = '' as $$
declare u uuid := auth.uid();
begin
 if u is not null and elite_private.is_admin(u) then return u; end if;
 if u is null or not exists(select 1 from auth.identities where user_id=u and provider='google') then raise exception 'Acceso Google obligatorio' using errcode='42501'; end if;
 if not (elite_private.schedule_at(clock_timestamp())->>'open')::boolean then raise exception 'Juego cerrado' using errcode='42501'; end if;
 return u;
end $$;
create or replace function public.elite_access_status() returns jsonb language plpgsql security definer set search_path = '' as $$
declare t timestamptz := clock_timestamp();
begin
 if elite_private.is_admin(auth.uid()) then
  return jsonb_build_object('server_now',t,'next_change',t+interval '24 hours','open',true,'admin',true,'timezone','Europe/Madrid');
 end if;
 return elite_private.schedule_at(t)||jsonb_build_object('admin',false);
end $$;
create or replace function public.elite_heartbeat() returns jsonb language plpgsql security definer set search_path = '' as $$
begin
 perform elite_private.require_player();
 return public.elite_access_status();
end $$;
revoke all on function public.elite_access_status() from public,anon,authenticated;
grant execute on function public.elite_access_status() to authenticated;
revoke all on function public.elite_heartbeat() from public,anon,authenticated;
grant execute on function public.elite_heartbeat() to authenticated;
commit;
