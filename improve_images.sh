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

# We verify that all arguments are specified
if [ "$#" -ne 4 ]; then
  echo "Using: $0 <input_folder> <output_folder> <model_name> <process_subfolders/1-true/0-false (default)>"
  echo "Example: $0 ./images/originals ./images/improved realesrgan-x4plus 1"
  exit 1
fi

# We assign the arguments to variables to facilitate their use
carpeta_entrada="$1"
carpeta_salida="$2"
modelo="$3"
subcarpetas="$4"



# Function to list files in a folder
procesar_archivos() {
    local current_directory="$1"    
    # We get the name of the last route folder to create it at the destination
    local sub_folder_name=$(echo "$current_directory" | rev | cut -d'/' -f1 | rev)
    echo "Processing files in the folder: $current_directory"
    local ruta_salida_final="$carpeta_salida/$sub_folder_name"
    echo "Files will be sent to the folder: $ruta_salida_final"        
    mkdir -p "$carpeta_salida"
    mkdir -p "$carpeta_salida/$sub_folder_name"
    for file in "$current_directory"/*; do
        if [ -f "$file" ]; then
            # We get the base name of the file (without the route)
            local file_name=$(basename "$file")
            echo "Original file name: $file"
            # We define the output file in the output folder
            local archivo_salida="$ruta_salida_final/${file_name%.*}_mejorado.webp"
            local archivo_salida_webp="$ruta_salida_final/${file_name%.*}_mejoradoc.webp"            
            echo "Output file in PNG format: $archivo_salida"
            echo "Output file in WEBP format: $archivo_salida_webp"
            ./realesrgan-ncnn-vulkan -i "$file" -o "$archivo_salida" -n "$modelo" -f webp
            cwebp -q 80 "$archivo_salida" -o "$archivo_salida_webp"            
            if [ $? -eq 0 ]; then
                echo "Processed and erasing origin: $file_name -> $archivo_salida"
                rm "$archivo_salida"
            else
                echo "Error when processing: $file_name"
            fi
        fi
    done
    echo ""
}


# Procesamos cada archivo en la raiz carpeta de entrada
cantidad_archivos=$(ls -p "$carpeta_entrada" | grep -v / | wc -l)
echo "Amount of files in the root: $cantidad_archivos"
if [ $cantidad_archivos -ne 0 ]; then
    procesar_archivos "${carpeta_entrada}"
fi

# We process each file in each subfolder if the parameter is 1 in subfolders
if [ $4 -eq 1 ]; then
    for directory in in "$carpeta_entrada"/*/; do    
        if [ -d "$directory" ]; then
            echo "${directory%/}"  # Remove the final diagonal bar
            ruta="$(dirname "$directory")"            
            procesar_archivos "${directory%/}" "$ruta"
        fi
    done
fi