# Elite Football 3D V9

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
