# Activación V15 — acceso privado

Si ya activaste la V14, conserva tu proyecto Supabase y sus credenciales públicas. No borres las cuentas ni las tablas existentes. Si aún no lo has activado, sigue primero `ACTIVAR_V14.md`.

1. En Supabase → Authentication → Providers, habilita Email (contraseña), además de Google. No habilites acceso anónimo. Para crear la cuenta exclusiva de administrador, en Authentication → Users añade un usuario con un correo exclusivo y una contraseña larga elegida por ti, con email confirmado. Si el hook Before User Created impide crear la cuenta desde el panel, pausa el hook solo durante la creación y vuelve a activarlo inmediatamente. El hook original debe quedar activo; prohíbe nuevos registros por email y registros Google fuera de horario. No publiques antes de reactivarlo.
2. Ejecuta `backend/admin-access.sql` en SQL Editor, después de `backend/setup.sql` (si este ya se ejecutó, no hace falta repetirlo). En Authentication → Users copia el UUID del usuario administrador. Ejecuta, sustituyendo exclusivamente el UUID por el real:

```sql
insert into elite_private.administrators(id)
values ('UUID_REAL_DEL_ADMINISTRADOR')
on conflict do nothing;
```

3. En `js/cloud-config.js` conserva `url` y `publishableKey` de la V14 y añade `adminEmail: 'CORREO_EXCLUSIVO_DEL_ADMIN'`. Este correo es un identificador público, no un secreto. **No pongas la contraseña en este archivo ni en GitHub.** La contraseña se configura exclusivamente en Supabase. Usa una cuenta dedicada, no una cuenta Google compartida con jugadores.
4. Publica el contenido de la V15 en la raíz de GitHub Pages. En Home pulsa «Acceso privado», introduce tu clave y entra. El servidor exige el UUID autorizado y una sesión autenticada mediante contraseña. Las credenciales del administrador no se guardan en localStorage; al recargar tendrás que introducir la clave otra vez. El acceso requiere Internet y se revalida periódicamente. La ficha y los récords del administrador son independientes.
5. Prueba fuera de horario: clave errónea rechazada; clave correcta y rol administrador permiten entrar; cuenta normal sigue bloqueada. Prueba también el registro Google en horario permitido y prohibido. Verifica que el hook está activo. Si revocas el UUID de administradores, se pierde el acceso excepcional en la siguiente comprobación del servidor. La clave se gestiona en Supabase. No compartas credenciales con nadie.

## Verificación y alcance

La prueba `node tests/check-access.cjs` comprueba el flujo mediante API simulada. La conexión real, la contraseña, los roles y la ejecución SQL deben verificarse en tu proyecto. GitHub Pages sigue sirviendo código público; los datos y el permiso de administrador se validan en servidor, no mediante una clave escrita en HTML. No es un sistema de protección de los archivos estáticos frente a copias modificadas.
