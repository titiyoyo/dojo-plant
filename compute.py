!pip install Pillow smartcrop matplotlib tensorflow numpy
%matplotlib inline

from pathlib import Path
from modules import dataload
from modules.model import create_model
from modules.model import save_model

import numpy as np
import tensorflow as tf
import tensorflow.keras as K

path_to_dataset = Path("data/dataset_dojo")
path_to_cropped = path_to_dataset / "cropped"
path_to_models = Path("out/models")

img_height = 300
img_width = 300

training_dataset = dataload.create_set(path_to_cropped, "training")
validation_dataset = dataload.create_set(path_to_cropped, "validation")

class_names = training_dataset.class_names
print(f"{class_names = }")
print(f"{len(class_names) = }")

training_dataset = training_dataset.cache().shuffle(1000).prefetch(buffer_size=tf.data.AUTOTUNE)
validation_dataset = validation_dataset.cache().prefetch(buffer_size=tf.data.AUTOTUNE)

#TODO : Ajouter un split de test pour comparer les differents types de modèles

image_batch, _ = next(iter(training_dataset))
first_image = image_batch[0]
print(f"Initial image values interval : [{np.min(first_image)}, {np.max(first_image)}]")

normalization_layer = K.layers.Rescaling(1./255)
normalized_ds = training_dataset.map(lambda x, y: (normalization_layer(x), y))
image_batch, labels_batch = next(iter(normalized_ds))
first_image = image_batch[0]

# Notice the pixel values are now in `[0,1]`.
print(f"Normalized image values interval : [{np.min(first_image)}, {np.max(first_image)}]")

num_classes = len(class_names)

model = create_model(
    input_shape=(img_height, img_width, 3),
    output_dim=num_classes
)

model.compile(optimizer='adam',
              loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
              metrics=['accuracy'])

epochs=30

history = model.fit(
  training_dataset,
  validation_data=validation_dataset,
  epochs=epochs
)

save_model(
    model_folder=path_to_models / "simple",
    model=model,
)

data_augmentation = K.Sequential([
    K.layers.RandomFlip(
        "horizontal",
        input_shape=(img_height, img_width, 3)
    ),
    K.layers.RandomRotation(0.1),
    K.layers.RandomZoom(0.1),
])

augmented_model = create_model(
    input_shape=(img_height, img_width, 3),
    output_dim=num_classes,
    augmented=True,
)

augmented_model.compile(
    optimizer='adam',
    loss=tf.keras.losses.SparseCategoricalCrossentropy(from_logits=True),
    metrics=['accuracy'],
)

augmented_model.summary()

epochs=30
history_aug = augmented_model.fit(
    training_dataset,
    validation_data=validation_dataset,
    epochs=epochs
)

from modules.model import save_model
save_model(
    model_folder=path_to_models / "augmented",
    model=augmented_model,
)