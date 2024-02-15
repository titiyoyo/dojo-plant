import os
from pathlib import Path

import tensorflow as tf
import tensorflow.keras as K


def get_images(path: str | Path, max_per_category: int = 100) -> list[Path]: 
    """
    
    """
    path = Path(path)
    
    if not path.exists():
        path.mkdir(parents=True, exist_ok=True)

    all_images = []

    for subfolder in path.iterdir():
        images = list(subfolder.glob("*.jpg"))
        all_images.extend(images[:max_per_category])
    
    return all_images


def get_images_alt(path: str | Path, max_per_category: int = 100) -> list[Path]: 
    """
    
    """
    path = Path(path)
    
    if not path.exists():
        path.mkdir(parents=True, exist_ok=True)

    return [
        image_path 
        for subfolder in path.iterdir()
        for image_path in subfolder.glob("*.jpg")
    ]


def create_set(data_dir: str | Path, label: str) -> tf.data.Dataset:
    """
    
    """
    data_dir = Path(data_dir)
    image_count = len(list(data_dir.glob("*.jpg")))
   
    # Alternative en O(1) en memoire
    # (on évite la rétention de tous les éléments du générateur)
    image_count_alt = sum(1 for _ in data_dir.glob("*.jpg"))

    assert image_count == image_count_alt
    
    print(f"Found {image_count} images in {data_dir}.")

    img_width = 300
    img_height = 300
    batch_size = 32
    
    return K.utils.image_dataset_from_directory(
        data_dir,
        validation_split=0.2,
        subset=label,
        seed=123,
        image_size=(img_height, img_width),
        batch_size=batch_size
    )