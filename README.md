# Script para Aumentar la Resolución y Convertir a WEBP

Este script utiliza la tecnología de inteligencia artificial `realesrgan-ncnn-vulkan` junto con el modelo `realesrgan-x4plus` para aumentar la resolución de las imágenes en 4x. Además, convierte cada archivo de formato PNG a WEBP para ahorrar espacio significativo sin pérdida de calidad.

## Características Principales:

- **Aumento de Resolución**: El script utiliza el modelo `realesrgan-x4plus` para aumentar la resolución de las imágenes en 4x, mejorando así la nitidez y los detalles.
- **Conversión a WEBP**: Después de aumentar la resolución, el script convierte las imágenes de formato PNG a WEBP, lo que reduce considerablemente el tamaño de archivo sin comprometer la calidad visual.
- **Optimización de Espacio**: Al convertir las imágenes a WEBP, se logra un ahorro significativo de espacio en disco, lo que es especialmente útil para almacenar grandes cantidades de imágenes.

#### Uso:

1. **Requisitos Previos**:
- En el repo se incluye `realesrgan-ncnn-vulkan` y el modelo `realesrgan-x4plus`.
- Debes instalar cwebp de Google para convertir las imagenes a Webp.

```bash
$ apt update
$ apt install webp
```

2. **Ejecución del Script**:
-Ejecuta el script proporcionando la ruta de la carpeta que contiene las imágenes que deseas procesar.

```bash
./improve_images.sh /ruta/a/tu/carpeta
```

3. **Resultados**: El script procesará todas las imágenes en la carpeta especificada, aumentando su resolución y convirtiéndolas a WEBP.

## Ejemplo:

Si tienes una carpeta llamada `/home/usuario/imagenes` con imágenes, puedes ejecutar el script de la siguiente manera:

```bash
./improve_images.sh /home/usuario/imagenes
```
El script generará imágenes con resolución aumentada (4x) y en formato WEBP en la misma carpeta.

## Beneficios:

- **Mejora de Calidad**: Las imágenes resultantes tienen una resolución 4 veces mayor, lo que mejora la calidad visual.
- **Ahorro de Espacio**: La conversión a WEBP reduce el tamaño de archivo, facilitando la gestión y almacenamiento de imágenes.
- **Automatización**: El script automatiza el proceso de aumento de resolución y conversión, ahorrando tiempo y esfuerzo.