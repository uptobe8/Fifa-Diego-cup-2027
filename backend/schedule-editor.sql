-- Optional: run after setup.sql and admin-access.sql if Google / cloud administration is enabled.
begin;
create table if not exists elite_private.schedule_settings (singleton boolean primary key default true check(singleton), hours jsonb not null);
alter table elite_private.schedule_settings enable row level security;
revoke all on elite_private.schedule_settings from public,anon,authenticated;
insert into elite_private.schedule_settings(singleton,hours) values(true,'[[["18:00","21:00"]],[["18:00","21:00"]],[["18:00","21:00"]],[["18:00","21:00"]],[["18:00","21:00"]],[["07:00","11:00"],["18:00","21:00"]],[["07:00","11:00"],["18:00","21:00"]]]'::jsonb) on conflict do nothing;
create or replace function public.elite_get_schedule() returns jsonb language plpgsql security definer set search_path='' as $$
begin
 if not elite_private.is_admin(auth.uid()) then raise exception 'Acceso no autorizado' using errcode='42501'; end if;
 return (select hours from elite_private.schedule_settings where singleton);
end $$;
create or replace function public.elite_set_schedule(p_hours jsonb) returns boolean language plpgsql security definer set search_path='' as $$
declare d jsonb; slot jsonb; a text; b text; previous_end text;
begin
 if not elite_private.is_admin(auth.uid()) then raise exception 'Acceso no autorizado' using errcode='42501'; end if;
 if p_hours is null or jsonb_typeof(p_hours)<>'array' or jsonb_array_length(p_hours)<>7 then raise exception 'Horario semanal inválido'; end if;
 for d in select value from jsonb_array_elements(p_hours) loop
  if jsonb_typeof(d)<>'array' or jsonb_array_length(d)>2 then raise exception 'Máximo dos franjas'; end if;
  previous_end:=null;
  for slot in select value from jsonb_array_elements(d) loop
   if jsonb_typeof(slot)<>'array' or jsonb_array_length(slot)<>2 then raise exception 'Franja inválida'; end if;
   a:=slot->>0;b:=slot->>1;
   if a is null or b is null or a!~'^([01][0-9]|2[0-3]):[0-5][0-9]$' or b!~'^([01][0-9]|2[0-3]):[0-5][0-9]$' or a>=b or (previous_end is not null and previous_end>=a) then raise exception 'Horario inválido o franjas solapadas'; end if;
   previous_end:=b;
  end loop;
 end loop;
 update elite_private.schedule_settings set hours=p_hours where singleton;
 return true;
end $$;
revoke all on function public.elite_get_schedule() from public,anon,authenticated;
revoke all on function public.elite_set_schedule(jsonb) from public,anon,authenticated;
grant execute on function public.elite_get_schedule() to authenticated;
grant execute on function public.elite_set_schedule(jsonb) to authenticated;
create or replace function elite_private.schedule_at(t timestamptz) returns jsonb language sql stable security definer set search_path='' as $$
with settings as (select hours from elite_private.schedule_settings where singleton),
local_day as (select (t at time zone 'Europe/Madrid')::date d),
days as (select d+n as d from local_day cross join generate_series(0,8) n),
windows as (select (d+(slot->>0)::time) at time zone 'Europe/Madrid' opens,(d+(slot->>1)::time) at time zone 'Europe/Madrid' closes from days cross join settings cross join lateral jsonb_array_elements(hours->(extract(isodow from d)::int-1)) slot)
select jsonb_build_object('server_now',t,'open',exists(select 1 from windows where t>=opens and t<closes),'next_change',coalesce((select closes from windows where t>=opens and t<closes limit 1),(select min(opens) from windows where opens>t),t+interval '1 day'),'timezone','Europe/Madrid','hours',(select hours from settings));
$$;
commit;
