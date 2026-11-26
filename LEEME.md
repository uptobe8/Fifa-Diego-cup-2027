# Elite Football 3D V8

Abre index.html en un navegador WebGL. En iPhone, la versión autónoma requiere un visor HTML compatible con JavaScript/WebGL o un alojamiento HTTPS. No es una aplicación iOS firmada.

## Controles
- Penaltis y dianas: toca/haz clic sobre la portería para fijar el punto. Mueve el puntero al botón DISPARAR sin cambiar la puntería; mantén y suelta para ajustar potencia. La curva altera la trayectoria y mantiene el destino.
- Toques: elige parte del cuerpo según la altura; cuatro velocidades; ranking por puntos y toques.
- Personalización: Cristiano Ronaldo, Al Nassr original y recoloreados, LaLiga y Adidas Champions League (mallas y texturas de los FBX aportados), balones alternativos, portero, trofeo opcional y dos MP3.
- Guardado y ranking locales al navegador.

## Recursos
Cristiano: 9 mallas con texturas y pesos de esqueleto originales; paleta de 13 articulaciones, poses procedurales, escala 1,85 m. Modelo original incluido con aviso de licencia. Estadios OBJ adaptados a coordenadas jugables, fondos gigantes y porterías duplicadas eliminados. Soccergoal: geometría original, textura de red con alfa. Balones originales FBX convertidos a geometría con UV y texturas. Brasil: variante de colores; no es la camiseta Maya original (no está riggeada para Cristiano). Trofeo 3MF simplificado.

## Verificación
`node tests/check-game.cjs`: pruebas con contexto GL simulado, control de puntería bloqueada, destino exacto con curva, 100 puntos en diana, toques, clasificación y guardado. Retrato de Cristiano renderizado por CPU a partir de las mallas/UV/texturas importadas. Chromium del entorno no permite WebGL; escena completa y rendimiento en dispositivos reales no verificados.

Los archivos proporcionados por el usuario conservan sus condiciones de licencia y derechos de imagen; revisar antes de redistribución pública.
