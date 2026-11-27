# V18 · Horarios privados

1. Entra mediante Acceso privado con tu clave personal.
2. En el menú, pulsa HORARIOS PRIVADOS. El botón solo se muestra en una sesión de administrador.
3. Confirma tu clave. Cada día tiene dos franjas independientes. Desactiva las dos para cerrar ese día.
4. Pulsa GUARDAR HORARIOS. Puedes restaurar los horarios originales y guardarlos.
5. Cierra sesión cuando termines; tu cuenta sigue sin límite horario.

En modo local, los horarios y la clave se conservan en el almacenamiento del navegador. El contador de la pantalla de acceso usa Europe/Madrid. Si se borra el almacenamiento, se pierde la configuración. El registro Google sigue bloqueado mientras Supabase no esté configurado. Con una configuración remota existente, las restricciones locales pueden reducir el horario autorizado por el servidor en ese navegador; no pueden ampliarlo ni sincronizarse con otros equipos. Los archivos públicos de GitHub Pages y el almacenamiento local no constituyen una barrera de seguridad frente a manipulación deliberada.

Si en el futuro se desea cambiar el horario de todos los dispositivos desde una cuenta de administrador de Supabase, aplicar backend/schedule-editor.sql después de setup.sql y admin-access.sql, y configurar la cuenta de administrador remota. Ese mecanismo valida el permiso en el servidor y usa el horario guardado para el registro, acceso y actividad. SQL no probado contra un proyecto Supabase real.

Verificación: pruebas Node de acceso, clave local, lógica del juego y nuevo editor de horarios en DOM simulado. Pendiente prueba visual en Safari/iPhone y comprobación de persistencia del visor Archivos.
