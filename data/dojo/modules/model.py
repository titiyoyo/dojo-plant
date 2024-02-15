from tensorflow import keras as K
from tensorflow.keras import layers
from tensorflow.keras.models import Sequential
from datetime import datetime as dt
import os


MODEL_ID_FORMAT = "%y%m%d-%H%M%S"


def create_model(input_shape:tuple[int], output_dim: int, augmented: bool = False) -> K.Model:
    input_main_cnn = {} if augmented else {"input_shape": input_shape}
    main_cnn = [
        layers.Rescaling(1./255, **input_main_cnn),
        layers.Conv2D(16, 3, padding='same', activation='relu'),
        layers.MaxPooling2D(),
        layers.Conv2D(32, 3, padding='same', activation='relu'),
        layers.MaxPooling2D(),
        layers.Conv2D(64, 3, padding='same', activation='relu'),
        layers.MaxPooling2D(),
        layers.Flatten(),
        layers.Dense(128, activation='relu'),
        layers.Dense(output_dim)
    ]

    augmentation_layer = K.Sequential([
        layers.RandomFlip("horizontal", input_shape=input_shape),
        layers.RandomRotation(0.1),
        layers.RandomZoom(0.1),
    ])
    
    return Sequential([augmentation_layer, *main_cnn] if augmented else main_cnn)


def load_model(model_folder: str, filename: str | None) -> K.Model | None:
    """
    Loads a Keras model form disk.
    
    :param str model_folder:  the models folder relative path.
    :param str? filename:     name of the model file (with extension). If None of not passed, load the latest model.

    :raises:
        OSError: if filename is provided and does not exist.
    """

    if filename is not None:
        return K.models.load_model(f"{model_folder}/{filename}")

    models = sorted(os.listdir(model_folder), reversed=True)
        
    return K.models.load_model(f"{model_folder}/{models[0]}") if models else None


def save_model(model_folder: str, model: K.Model, format: str = "tf"):
    """
    Saves a Keras model to disk.
    
    :param str model_folder:     the models folder relative path.
    :param tf.keras.Model model: model to serialize.
    :param str format:           format of the SavedModel file. Defaults to "tf".

    :raises:
        ValueError: if format not one of "keras", "tf", "h5".
    """
    
    if format not in ("keras", "tf", "h5"):
        raise ValueException("Unknown format.")
    
    extension = "h5" if format == "h5" else "keras"
    
    model_name = dt.now().strftime(MODEL_ID_FORMAT)
    
    model.save(f"{model_folder}/{model_name}.{extension}")