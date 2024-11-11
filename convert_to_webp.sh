#!/bin/bash

# Comprobamos que se hayan especificado todos los argumentos
if [ "$#" -ne 4 ]; then
  echo "Uso: $0 <carpeta_entrada> <carpeta_salida> <escala> <nombre_modelo>"
  echo "Ejemplo: $0 ./imagenes/originales ./imagenes/mejoradas 4 realesrgan-x4plus"
  exit 1
fi

# Asignamos los argumentos a variables para facilitar su uso
carpeta_entrada="$1"
carpeta_salida="$2"
escala="$3"
modelo="$4"

# Creamos la carpeta de salida si no existe
mkdir -p "$carpeta_salida"

# Procesamos cada archivo en la carpeta de entrada
for archivo in "$carpeta_entrada"/*; do
  # Obtenemos el nombre base del archivo (sin la ruta)
  nombre_archivo=$(basename "$archivo")
  # Definimos el archivo de salida en la carpeta de salida
  archivo_salida="$carpeta_salida/${nombre_archivo%.*}.webp"
  archivo_salida_webp="$carpeta_salida/${nombre_archivo%.*}_g.webp"
  
  # Ejecutamos el comando con los parámetros especificados
  #./realesrgan-ncnn-vulkan -i "$archivo" -o "$archivo_salida" -s "$escala" -n "$modelo"

  cwebp -q 80 "$archivo_salida" -o "$archivo_salida_webp"
  # Comprobamos si el comando se ejecutó correctamente
  if [ $? -eq 0 ]; then
    echo "Procesado: $nombre_archivo -> $archivo_salida Borrando archivo PNG"
    rm $archivo_salida
  else
    echo "Error al procesar: $nombre_archivo"
  fi
done
