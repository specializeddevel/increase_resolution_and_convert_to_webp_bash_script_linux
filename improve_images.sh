#!/bin/bash

# https://github.com/NightmareAI/Real-ESRGAN?tab=readme-ov-file#-demos-videos
# Usage: realesrgan-ncnn-vulkan -i infile -o outfile [options]...

#   -h                   show this help
#   -i input-path        input image path (jpg/png/webp) or directory
#   -o output-path       output image path (jpg/png/webp) or directory
#   -s scale             upscale ratio (can be 2, 3, 4. default=4)
#   -t tile-size         tile size (>=32/0=auto, default=0) can be 0,0,0 for multi-gpu
#   -m model-path        folder path to the pre-trained models. default=models
#   -n model-name        model name (default=realesr-animevideov3, can be realesr-animevideov3 | realesrgan-x4plus | realesrgan-x4plus-anime | realesrnet-x4plus)
#   -g gpu-id            gpu device to use (default=auto) can be 0,1,2 for multi-gpu
#   -j load:proc:save    thread count for load/proc/save (default=1:2:2) can be 1:2,2,2:2 for multi-gpu
#   -x                   enable tta mode"
#   -f format            output image format (jpg/png/webp, default=ext/png)
#   -v                   verbose output

# Comprobamos que se hayan especificado todos los argumentos
if [ "$#" -ne 4 ]; then
  echo "Uso: $0 <carpeta_entrada> <carpeta_salida> <nombre_modelo> <procesar_subcarpetas/1-true/0-false (default)>"
  echo "Ejemplo: $0 ./imagenes/originales ./imagenes/mejoradas 4 realesrgan-x4plus"
  exit 1
fi

# Asignamos los argumentos a variables para facilitar su uso
carpeta_entrada="$1"
carpeta_salida="$2"
modelo="$3"
subcarpetas="$4"

# Creamos la carpeta de salida si no existe


# Función para listar archivos en una carpeta
procesar_archivos() {
    local current_directory="$1"    
    #Obtenemos el nombre de la ultima carpeta de la ruta para crearla en el destino
    local sub_folder_name=$(echo "$current_directory" | rev | cut -d'/' -f1 | rev)
    echo "Procesando archivos en la carpeta: $current_directory"
    local ruta_salida_final="$carpeta_salida/$sub_folder_name"
    echo "Se enviaran archivos a la carpeta: $ruta_salida_final"        
    mkdir -p "$carpeta_salida"
    mkdir -p "$carpeta_salida/$sub_folder_name"
    for file in "$current_directory"/*; do
        if [ -f "$file" ]; then
            # Obtenemos el nombre base del archivo (sin la ruta)
            local file_name=$(basename "$file")
            echo "nombre de archivo origen: $file"
            # Definimos el archivo de salida en la carpeta de salida
            local archivo_salida="$ruta_salida_final/${file_name%.*}_mejorado.png"
            local archivo_salida_webp="$ruta_salida_final/${file_name%.*}_mejorado.webp"            
            echo "nombre de archivo de salida PNG: $archivo_salida"
            echo "nombre de archivo de salida WEBP: $archivo_salida_webp"
            ./realesrgan-ncnn-vulkan -i "$file" -o "$archivo_salida" -n "$modelo"
            cwebp -q 80 "$archivo_salida" -o "$archivo_salida_webp"            
            if [ $? -eq 0 ]; then
                echo "Procesado y borrando origen: $file_name -> $archivo_salida"
                rm "$archivo_salida"
            else
                echo "Error al procesar: $file_name"
            fi
        fi
    done
    echo ""
}


# Procesamos cada archivo en la raiz carpeta de entrada
cantidad_archivos=$(ls -p "$carpeta_entrada" | grep -v / | wc -l)
echo "Cantidad de archivos en la raiz: $cantidad_archivos"
if [ $cantidad_archivos -ne 0 ]; then
    procesar_archivos "${carpeta_entrada}"
fi

# Procesamos cada archivo en cada subcarpeta si el parametro es 1 en subcarpetas
if [ $4 -eq 1 ]; then
    for directory in in "$carpeta_entrada"/*/; do    
        if [ -d "$directory" ]; then
            echo "${directory%/}"  # Eliminar la barra diagonal final
            ruta="$(dirname "$directory")"            
            procesar_archivos "${directory%/}" "$ruta"
        fi
    done
fi