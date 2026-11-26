-- Ejecutar tras setup.sql. Debe devolver cero filas.
with cases(t,expected) as (values
 ('2026-11-23 17:59:59 Europe/Madrid'::timestamptz,false),('2026-11-23 18:00 Europe/Madrid'::timestamptz,true),('2026-11-23 20:59:59 Europe/Madrid'::timestamptz,true),('2026-11-23 21:00 Europe/Madrid'::timestamptz,false),
 ('2026-11-28 06:59 Europe/Madrid'::timestamptz,false),('2026-11-28 07:00 Europe/Madrid'::timestamptz,true),('2026-11-28 11:00 Europe/Madrid'::timestamptz,false),('2026-11-29 18:00 Europe/Madrid'::timestamptz,true),('2026-11-29 21:00 Europe/Madrid'::timestamptz,false),
 ('2027-03-28 07:00 Europe/Madrid'::timestamptz,true),('2027-10-31 11:00 Europe/Madrid'::timestamptz,false))
select t,expected,elite_private.schedule_at(t) as actual from cases where (elite_private.schedule_at(t)->>'open')::boolean<>expected;
