from module import dataload, model

def train():
    pass

path_to_dataset = './data/dataset'
path_to_cropped = path_to_dataset + '/cropped'
path_to_other = path_to_dataset + '/other'
path_to_unsorted = path_to_dataset + '/unsorted'

img_height = 300
img_width = 300

import tensorflow as tf
from modules import dataload

training_dataset = dataload.create_set(path_to_cropped, "training")
validation_dataset = dataload.create_set(path_to_cropped, "validation")

class_names = training_dataset.class_names
print(f"{class_names = }")
print(f"{len(class_names) = }")

training_dataset = training_dataset.cache().shuffle(1000).prefetch(buffer_size=tf.data.AUTOTUNE)
validation_dataset = validation_dataset.cache().prefetch(buffer_size=tf.data.AUTOTUNE)

#TODO : Ajouter un split de test pour comparer les differents types de modèles

if __name__ == "__main__":
    train()