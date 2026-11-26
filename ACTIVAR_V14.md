# Activación de Elite Football 3D V14

Esta versión no permite acceso anónimo ni acceso sin validación del servidor. No publiques la V14 sobre la V13 en producción antes de completar la configuración y probarla.

## 1. Supabase y base de datos

1. Crea un proyecto dedicado en https://supabase.com/dashboard.
2. En SQL Editor ejecuta íntegramente `backend/setup.sql`. Crea las tablas privadas, las funciones RPC, la comprobación del horario y el hook de registro. Ejecuta `backend/check-schedule.sql`: debe devolver cero filas.
3. En Authentication → Hooks, habilita **Before User Created** y selecciona la función Postgres `public.elite_signup_hook`. Este paso es imprescindible: bloquea la creación de nuevas cuentas de Google fuera de horario en el servidor, no solo en la interfaz.
4. En Authentication → Providers / Sign In, deja Google habilitado y deshabilita los proveedores que no se necesiten. No habilites acceso anónimo.

## 2. Google OAuth

1. Crea una aplicación OAuth de tipo web en https://console.cloud.google.com/ (Google Auth Platform). Configura la pantalla de consentimiento; mientras esté en pruebas, añade los usuarios de prueba correspondientes.
2. Origen JavaScript autorizado: `https://uptobe8.github.io`.
3. URI de redirección autorizada: `https://TU_PROYECTO.supabase.co/auth/v1/callback` (copia la URL real que muestra Supabase en la configuración de Google).
4. Copia Client ID y Client Secret de Google en el proveedor Google de Supabase. Nunca pongas el Client Secret en GitHub.
5. En Supabase Authentication → URL Configuration, configura Site URL y Redirect URL exacta: `https://uptobe8.github.io/Fifa-Diego-cup-2027/`.

Documentación oficial: https://supabase.com/docs/guides/auth/social-sign-in/auth-google y https://supabase.com/docs/guides/auth/auth-hooks/before-user-created-hook.

## 3. Conectar la web

Edita únicamente `js/cloud-config.js` con los valores reales del proyecto:

```js
window.ELITE_CONFIG = {
  url: 'https://TU_PROYECTO.supabase.co',
  publishableKey: 'TU_CLAVE_PUBLICABLE'
};
```

Utiliza la clave **publishable** (o anon pública equivalente). No utilices secret key, service_role ni contraseña de la base de datos. Sube el contenido del ZIP a la raíz del repositorio existente, conservando las carpetas. La URL debe coincidir exactamente con la configuración de OAuth. Esta versión necesita HTTPS e Internet; no es una edición autónoma sin conexión.

## 4. Comprobación final antes de publicar

- Durante horario permitido: cuenta Google nueva, alta automática, cierre e inicio de sesión, nombre editable, preferencias y partida sincronizadas, récord nuevo en cada modalidad, cierre de sesión y comprobación desde un segundo navegador. Otra cuenta no debe acceder a la ficha o partidas de la primera.
- Fuera de horario: no aparece acceso operativo, se muestra la cuenta atrás hasta la próxima apertura, el hook rechaza una nueva alta incluso por OAuth directo, RPC privadas rechazan peticiones. En el límite de cierre se oculta el juego y se detiene la simulación.
- Horario Europe/Madrid: lunes a viernes 18:00–21:00; sábado y domingo 07:00–11:00 y 18:00–21:00. Inicio incluido, final excluido. La base de datos calcula la hora y el siguiente cambio; el navegador usa un reloj monotónico y revalida en el servidor. Sin conexión no se permite jugar.
- La ficha se identifica por el UUID de Supabase, no por nombre ni email. El historial y preferencias anteriores de V13 sin cuenta no se importan automáticamente: hacerlo podría asignar récords de otra persona a la cuenta recién creada. El historial mostrado conserva las últimas 2.000 partidas, y los récords se calculan sobre todas las registradas en el servidor.
- Google gestiona la contraseña: el enlace de la ficha abre la configuración de seguridad de la cuenta. No se pide ni se guarda la contraseña de Google en el juego.
- Las partidas activas se sincronizan periódicamente (cada ~8 s con cambios); al cierre se conserva la última sincronización confirmada. El tiempo total suma partidas completadas registradas. Los resultados son personales, no un ranking competitivo global verificado: la simulación es cliente y el servidor comprueba límites básicos, no repite cada jugada.

## Límites de esta entrega

No se han creado ni configurado cuentas reales de Supabase o Google. Las pruebas `node tests/check-game.cjs` y `node tests/check-access.cjs` usan APIs simuladas, y no sustituyen la prueba real de OAuth y SQL. GitHub Pages sirve archivos públicos: la interfaz normal, el alta y los datos del servidor se bloquean; quien descargue/modifique el código cliente podría ejecutar una copia local. Para proteger también el acceso a los archivos y validar partidas contra trampas haría falta alojamiento privado con autorización y lógica de juego en el servidor. Revisa los derechos de los modelos y los avisos de privacidad antes de publicar, en especial si participan menores.
