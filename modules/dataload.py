import pathlib, os

def get_images(path): 
  pathExist = os.path.exists(path)
  if not pathExist:
    pathlib.Path(path).mkdir(parents=True, exist_ok=True)

  pathlib_instance = pathlib.Path(path)
  images = []

  for current_path in pathlib_instance.iterdir():
    current_dir = pathlib.Path(current_path)
    images = list(current_dir.glob('**/*.jpg'))
    images.extend(images[:100])
  
  return images
