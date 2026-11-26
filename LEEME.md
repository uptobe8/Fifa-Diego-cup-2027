# Elite Football 3D · V6

## Uso
- En ordenador, descomprime la carpeta y abre index.html en un navegador compatible con WebGL. No requiere descargas externas.
- La versión HTML autónoma contiene los mismos recursos de ejecución y música. En iOS requiere un navegador/visor que ejecute JavaScript y WebGL; la vista previa de Archivos no es un navegador de juego.

## Cambios
- Nuevo futbolista texturizado obtenido de professional-soccer-standing.glb. El archivo original carece de esqueleto y animaciones; los pesos se han transferido de forma aproximada al esqueleto de la V5. Las texturas de color base se muestrean sobre los vértices. No se ha verificado visualmente la deformación.
- Geometría adaptada del estadio y de la portería aportados; se conserva la red procedural. Balón clásico sustituido por la geometría del balón del GLB. Los otros balones mantienen su diseño anterior.
- Siete tipos de toque, puntos flotantes, bonus de racha cada cinco toques, velocidades fácil/normal/rápido/experto, rankings por toques y puntos, persistencia de partida. Los movimientos usan las animaciones existentes; no hay siete capturas de movimiento independientes.
- Se mantienen los dos MP3, los modos penaltis/dianas, las opciones de equipación y el efecto de balón.
- El ZIP de recursos no contiene un modelo inequívocamente identificado como Cristiano Ronaldo. No se presenta el modelo genérico como Ronaldo.
- No se han convertido los modelos FBX de los balones Adidas/LaLiga, la copa 3MF ni la camiseta Maya. No se ha verificado la licencia de los recursos aportados del estadio/portería; revisar antes de distribuir públicamente.

## Pruebas
`node tests/check-game.cjs`
Pruebas de lógica y almacenamiento ejecutadas con WebGL simulado. La navegación local del navegador de pruebas está bloqueada; el renderizado real y la compatibilidad iOS no se han certificado.
