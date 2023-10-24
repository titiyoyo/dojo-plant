import pathlib

from tensorflow import keras

def create_set(data_dir, label):
  data_dir = pathlib.Path(data_dir)
  data_dir.absolute()

  image_count = len(list(data_dir.glob('*/*.jpg')))
  print(image_count)

  img_width = 300
  img_height = 300
  batch_size = 32
  
  return keras.utils.image_dataset_from_directory(
    data_dir,
    validation_split=0.2,
    subset=label,
    seed=123,
    image_size=(img_height, img_width),
    batch_size=batch_size)