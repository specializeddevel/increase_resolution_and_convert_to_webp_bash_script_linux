#!/bin/bash

# Comprobamos que se hayan especificado todos los argumentos
if [ "$#" -ne 4 ]; then
  echo "Uso: $0 <carpeta_entrada> <carpeta_salida> <procesar_subcarpetas> (1-true/0-false) <delete_source_file> (1-true/0-false)"
  echo "Ejemplo: $0 ./imagenes/originales ./imagenes/mejoradas 1"
  exit 1
fi

# Asignamos los argumentos a variables para facilitar su uso
carpeta_entrada="$1"
carpeta_salida="$2"
subcarpetas="$3"
delete_source_file="$4"


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
            local archivo_salida_webp="$ruta_salida_final/${file_name%.*}.webp"                        
            echo "nombre de archivo de salida WEBP: $archivo_salida_webp"            
            cwebp -q 80 "$file" -o "$archivo_salida_webp"            
            #Si todo termino correctamente
            if [ $? -eq 0 ]; then
                if [ $delete_source_file -eq 1 ]; then
                    echo "Borrando origen: $file_name -> $archivo_salida_webp"
                    rm "$file"
                fi
                echo "Proceso concluido: $file_name -> $archivo_salida_webp"
            else
                echo "Error al procesar: $file"
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
if [ $3 -eq 1 ]; then
    for directory in in "$carpeta_entrada"/*/; do    
        if [ -d "$directory" ]; then
            echo "${directory%/}"  # Eliminar la barra diagonal final
            ruta="$(dirname "$directory")"            
            procesar_archivos "${directory%/}" "$ruta"
        fi
    done
fi