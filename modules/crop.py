import smartcrop
import os

from PIL import Image

crop_height = 300
crop_width = 300

def crop_images(all_images, path_to_cropped):
  for image_path in all_images:
        print(f'processing {image_path}')
        image = Image.open(image_path)
        folder, filename = str(image_path).split('/')[-2:]
        sc = smartcrop.SmartCrop()
        ret = sc.crop(image, crop_height, crop_width)
        box = (ret['top_crop']['x'],
                ret['top_crop']['y'],
                ret['top_crop']['width'] + ret['top_crop']['x'],
                ret['top_crop']['height'] + ret['top_crop']['y'])
        img = image.crop(box)

        croppedFolder = f"{path_to_cropped}"
        if not os.path.exists(path_to_cropped):
            os.mkdir(path_to_cropped)

        specieFolder = f"{path_to_cropped}/{folder}"
        if not os.path.exists(specieFolder):
            os.mkdir(specieFolder)

        img.save(f"{specieFolder}/{filename}") 