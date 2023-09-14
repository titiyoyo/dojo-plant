import pathlib

def get_images(path): 
  pathlib_instance = pathlib.Path(path)
  images = []

  for current_path in pathlib_instance.iterdir():
    current_dir = pathlib.Path(current_path)
    images = list(current_dir.glob('**/*.jpg'))
    images.extend(images[:100])
  
  return images
