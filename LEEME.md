# Elite Football 3D V16
Acceso privado local sin configuración: consulta ACCESO_V16.md. El registro Google de jugadores requiere activar el servicio según ACTIVAR_V14.md. El acceso privado local solo protege el flujo normal de la interfaz; no constituye autenticación de servidor.

# Elite Football 3D V11

Abre index.html en un navegador WebGL. En iPhone, la versión autónoma requiere un visor HTML compatible con JavaScript/WebGL o un alojamiento HTTPS. No es una aplicación iOS firmada.

## Controles
- Penaltis y dianas: toca/haz clic sobre la portería para fijar el punto. Mueve el puntero al botón DISPARAR sin cambiar la puntería; mantén y suelta para ajustar potencia. La curva altera la trayectoria y mantiene el destino.
- Toques: elige parte del cuerpo según la altura; cuatro velocidades; ranking por puntos y toques.
- Personalización: Cristiano Ronaldo, Al Nassr original y recoloreados, LaLiga y Adidas Champions League (mallas y texturas de los FBX aportados), balones alternativos, portero, trofeo opcional y dos MP3.
- Guardado y ranking locales al navegador.

## Recursos
Cristiano: 9 mallas con texturas y pesos de esqueleto originales; paleta de 13 articulaciones, poses procedurales, escala 1,85 m. Modelo original incluido con aviso de licencia. Estadios OBJ adaptados a coordenadas jugables, fondos gigantes y porterías duplicadas eliminados. Soccergoal: geometría original, textura de red con alfa. Balones originales FBX convertidos a geometría con UV y texturas. Brasil: variante de colores; no es la camiseta Maya original (no está riggeada para Cristiano). Trofeo 3MF simplificado.

## Verificación
`node tests/check-game.cjs`: pruebas con contexto GL simulado, control de puntería bloqueada, destino exacto con curva, 100 puntos en diana, toques, clasificación y guardado. Retrato de Cristiano renderizado por CPU a partir de las mallas/UV/texturas importadas. La navegación local file:// de Chromium está bloqueada por el entorno de pruebas; escena completa y rendimiento en dispositivos reales no verificados.

Los archivos proporcionados por el usuario conservan sus condiciones de licencia y derechos de imagen; revisar antes de redistribución pública.

## V9
- Lamine Yamal y Neymar seleccionables además de Cristiano. Lamine conserva pesos originales reducidos a 13 articulaciones. Neymar no trae esqueleto: se ha añadido un rig aproximado, no animaciones originales.
- Portero anterior sustituido en el render por el modelo aportado de P-Vi.Art: 33 mallas, textura original, clip de recepción de 2,73 s adaptado y estiradas laterales procedurales. Sólo equipación original para portero y Neymar (atlas compartido).
- Atribuciones CC BY 4.0 en assets/licenses; derechos de imagen independientes.

Pruebas V9: selección y rutas de render de los tres jugadores y portero de 33 mallas, clip de 66 fotogramas, verificadas con contexto GL simulado.

## V10
Vestuario reducido a tres futbolistas (retratos renderizados a partir de sus propias mallas y texturas) y dos balones originales. Equipación original fija, música trasladada al menú. Los escenarios se han vuelto a convertir desde Stadium.obj y FutbolSahası.obj. Se conservan graderíos, estructuras y luces originales; se simplifican asientos repetidos y se eliminan porterías/objetos duplicados. Se recuperó la textura de campo original de Stadium del RAR Yeni+WinRAR; se adaptó su escala para situar el punto de penalti a 11 m. En Futbol Sahası la textura de césped externa no está incluida: se utiliza césped generado y líneas propias, con la portería original amarilla del OBJ. No es una copia visual exacta del archivo Blender.

## V11
Selector de estadio independiente de la modalidad: automático, LOW POLY Stadium y Futbol Sahası. La elección se guarda en preferencias locales. Se incorpora un selector de archivo de audio autorizado por el usuario: el archivo se reproduce localmente y no se sube ni se conserva tras cerrar la página. Se mantienen las dos canciones originales. No se añaden canciones de DJ Marta sin licencia verificable. No hay nuevos modelos de botas o jugadores en esta entrega.

## V12
Cuatro jugadores (Neymar PSG nuevo, con esqueleto original reducido a 13 articulaciones; clip de 5,7 s retargeteado a la pose de menú). Seis botas nuevas y originales: modelos reales, ajuste a los pies animados; en Neymar anterior se superponen debido a la malla compartida. Johan Cruyff Arena seleccionable, geometría simplificada, colores de material y césped generado. Back to Eurodance Anthem de HasenChat, MP3 aportado. No es DJ Marta. Las licencias de los archivos adjuntos se conservan donde están disponibles. Comprobar derechos antes de publicar.

## V13
Galería con imágenes de los modelos reales y previsualización 3D rotatoria de jugadores, balones, estadios y botas. Pulsa una tarjeta, gira y acerca, y confirma con ELEGIR. El último GLB de Ámsterdam es idéntico (SHA-256) al de V12, por lo que se conserva una sola opción. Las miniaturas de estadios son renderizados de las mallas optimizadas; Originales muestra un recorte de las botas de cada jugador.

## V14
Acceso obligatorio mediante Google, ficha individual, nombre editable, contraseña administrada por Google, récords, preferencias y partida sincronizados con Supabase. Temporizador con horario Europe/Madrid, cierre automático, revalidación y bloqueo si no hay conexión. Lee `ACTIVAR_V14.md` antes de desplegar. Se requiere configurar Supabase y Google OAuth: no hay modo invitado ni configuración ficticia. Las pruebas de interfaz y juego usan mocks; SQL y OAuth real quedan pendientes de configuración y comprobación. GitHub Pages no protege la descarga directa del código.

## V15
Acceso privado de administrador fuera de horario. Consulta ACTIVAR_V15.md. Los jugadores normales mantienen las reglas V14.

## V18
Panel privado de horarios, con confirmación de contraseña, dos franjas diarias, restauración y contador en horario de Madrid. Consultar HORARIOS_V18.md para alcance local y opcional sincronización remota.
