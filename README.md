# Script to Upscale Resolution and Convert Images to WEBP

This script leverages the AI-based tool `realesrgan-ncnn-vulkan` along with the `realesrgan-x4plus` model to upscale image resolution by 4x. Additionally, it converts PNG files to WEBP format to save significant storage space without compromising quality.

## Key Features:

- **Resolution Upscaling**: The script uses the `realesrgan-x4plus` model to upscale images by 4x, enhancing sharpness and detail.
- **Conversion to WEBP**: After upscaling, the script converts PNG images to WEBP format, significantly reducing file size while maintaining visual quality.
- **Space Optimization**: Converting images to WEBP format results in substantial disk space savings, making it ideal for managing large collections of images.

## Usage:

### 1. **Prerequisites**:
- Install Google's `cwebp` tool for WEBP conversion:

```bash
$ sudo apt update
$ sudo apt install webp
```

- The repository includes the `realesrgan-ncnn-vulkan` tool and the `realesrgan-x4plus` model.

### 2. **Run the Script**:
Run the script with the following syntax:

```bash
./improve_images.sh /pictures/original /pictures/enhanced realesrgan-x4plus 1
```

**Parameters**:
1. Path to the original images to be processed and converted to WEBP.  
2. Path to the directory where the enhanced and converted images will be saved.  
3. AI model to use (e.g., `realesrgan-x4plus`).  
4. `1` to include subfolders in processing, `0` to exclude subfolders.

### 3. **Results**:
The script processes all images in the specified folder, upscaling their resolution by 4x and converting them to WEBP format.

---

## Example:

Suppose you have a directory `/home/user/images` containing images. You can process them with the following command:

```bash
./improve_images.sh /home/user/images /home/user/optimized-images realesrgan-x4plus 1
```

The script will generate 4x upscaled images in WEBP format and save them in the `/home/user/optimized-images` folder.

---

## Benefits:

- **Enhanced Quality**: Output images are upscaled by 4x, resulting in higher visual quality.  
- **Space Efficiency**: Conversion to WEBP format significantly reduces file size, making storage management easier.  
- **Automation**: The script streamlines the process of resolution enhancement and conversion, saving time and effort.  

By automating these tasks, this script simplifies image optimization for various projects and applications.