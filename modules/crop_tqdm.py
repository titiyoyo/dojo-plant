import os
from pathlib import Path

from PIL import Image
import smartcrop
from tqdm import tqdm

crop_height = 300
crop_width = 300

def crop_images(
    all_images: list[Path],
    path_to_cropped: list[Path],
    verbose: bool = False,
):
    images_iterator = tqdm(all_images) if not verbose else all_images

    for image_path in images_iterator:
        if verbose:
            print(f'Processing {image_path}')

        image = Image.open(image_path)
        folder, filename = str(image_path).split('/')[-2:]
        sc = smartcrop.SmartCrop()
        ret = sc.crop(image, crop_height, crop_width)
        box = (
            ret['top_crop']['x'],
            ret['top_crop']['y'],
            ret['top_crop']['width'] + ret['top_crop']['x'],
            ret['top_crop']['height'] + ret['top_crop']['y']
        )
        img = image.crop(box)

        croppedFolder = f"{path_to_cropped}"
        if not os.path.exists(path_to_cropped):
            os.mkdir(path_to_cropped)

        specieFolder = f"{path_to_cropped}/{folder}"
        if not os.path.exists(specieFolder):
            os.mkdir(specieFolder)

        img.save(f"{specieFolder}/{filename}") 
