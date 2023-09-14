import smartcrop
import os

from PIL import Image

def crop_images(all_images, path_to_cropped):
  for image_path in all_images:
      image = Image.open(image_path)
      folder, filename = str(image_path).split('/')[-2:]
      sc = smartcrop.SmartCrop()
      ret = sc.crop(image, 300, 300)
      box = (ret['top_crop']['x'],
            ret['top_crop']['y'],
            ret['top_crop']['width'] + ret['top_crop']['x'],
            ret['top_crop']['height'] + ret['top_crop']['y'])
      img = image.crop(box)
      if not os.path.exists(path_to_cropped + folder):
          os.mkdir(path_to_cropped + folder)
      img.save(f"{path_to_cropped}/{folder}/{filename}") 