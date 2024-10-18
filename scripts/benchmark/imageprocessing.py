import os
import cv2
import numpy as np
from utils import load_model
import torch
import pandas as pd
from PIL import Image
from torchvision.models import mobilenet_v3_large, MobileNet_V3_Large_Weights, Weights
from torchvision.io import decode_image, read_file
from torchvision.transforms import transforms
from colorama import Fore, Back, Style

modelsFolder = '/Users/terence/Dev/projects/pro/rf/dojo-ml/models/mobilenet'
modelsFolderAbsPath = os.path.abspath(modelsFolder)
bbox = {
  "x": 224,
  "y": 224
}

# Charger le modèle MobileNet SSD
net = cv2.dnn.readNetFromCaffe(
  f"{modelsFolderAbsPath}/object_detection/deploy.prototxt", 
  f"{modelsFolderAbsPath}/object_detection/mobilenet_iter_73000.caffemodel"
)

# Couleurs pour dessiner les bounding boxes
COLORS = np.random.uniform(0, 255, size=(10, 3))

def processImage(file, imgSavePath):
  head, tail = os.path.split(file)
  processedImagePath = f"{imgSavePath}/{tail}"

  print(Fore.GREEN + f"file: {file}" + Style.RESET_ALL)
  
  img = cv2.imread(file)
  h, w, c = img.shape

  bbCoords, idx = detect_subject(img)
  label = detect_plant_name(file)
  
  if bbCoords is None:
    (startPoint, endPoint) = getBoundingBox(h, w)
    bbCoords = [startPoint[0], startPoint[1], endPoint[0], endPoint[1]]
    imgWithRectangle = drawRectangleFromImage(img, startPoint, endPoint)
  else:
    imgWithRectangle = drawRectangleFromCoords(img, bbCoords, label, idx)
  
  cv2.imwrite(processedImagePath, imgWithRectangle)
  
  crop_img = getCroppedImage(img, bbCoords)      
  
  if not (crop_img.size and crop_img.ndim):
    print(type(img), len(img), img.shape)
    print(crop_img, bbCoords)
    return {
      'label': label,
      'green': 0,
      'brown': 0,
      'blurriness': 0, 
      'brightness': 0, 
      'file': f"../{processedImagePath}"
    }
  else:
    blurriness = calculateScore(crop_img)
    greenPercentage = calculateGreen(crop_img)
    brownPercentage = calculateBrown(crop_img)
    brightness = calculateBrightness(crop_img)

    return {
      'label': label,
      'green': greenPercentage,
      'brown': brownPercentage,
      'blurriness': blurriness, 
      'brightness': brightness, 
      'file': f"../{processedImagePath}"
    }


# vérifier que bbcoords est contenue dans l'image
# utiliser img.shape pour avoir les dimensions de l'image
def getCroppedImage(img, bbCoords):
  startX, startY, endX, endY = bbCoords
    
  startX = int(startX)
  endX = int(endX)
  startY = int(startY)
  endY = int(endY)
  
  crop_img = img[startX:endX, endY:startY]
  
  return crop_img


def calculateBrightness(img):
  hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
  avg = np.mean(hsv[:,:, 2])
  per = (avg/255)*100

  return per


def getBoundingBox(h, w):
  centerX = w//2
  centerY = h//2
  
  start_point = (centerX-(bbox["x"]//2), centerY+(bbox["y"]//2))
  end_point = (centerX+(bbox["x"]//2), centerY-(bbox["y"]//2))
  
  return start_point, end_point


def drawRectangleFromCoords(img, bbCoords, label, idx):
  startX, startY, endX, endY = bbCoords
  startPoint = (int(startX), int(startY))
  endPoint = (int(endX), int(endY))
  
  img = cv2.rectangle(img, startPoint, endPoint, None, 2)
  y = startY - 15 if startY - 15 > 15 else startY + 15
  img = cv2.putText(img, label, (int(startX), int(y)), cv2.FONT_HERSHEY_SIMPLEX, 0.5, None, 2)
  
  return img


def drawRectangleFromImage(img, start_point, end_point):
  color = (0, 0, 255)
  thickness = 2

  return cv2.rectangle(
    img, 
    start_point, 
    end_point, 
    color, 
    thickness
  )


def calculateBrown(img):
  # Définir la plage pour la couleur verte en HSV
  lower_brown = np.array([10, 100, 20])  # Limite inférieure (ajuster si nécessaire)
  upper_brown = np.array([30, 255, 200])  # Limite supérieure (ajuster si nécessaire)
  
  return calculateColor(img, lower_brown, upper_brown)


def calculateGreen(img):  
  # Définir la plage pour la couleur verte en HSV
  lower_green = np.array([40, 40, 40])  # Limite inférieure
  upper_green = np.array([80, 255, 255])  # Limite supérieure
  
  return calculateColor(img, lower_green, upper_green)


def calculateColor(img, lower_range, upper_range):
  if img is None:
    return 0
  
  hsv_image = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)

  # Créer un masque qui capture les pixels verts
  mask = cv2.inRange(hsv_image, lower_range, upper_range)

  # Compter le nombre de pixels verts
  colored_pixels = np.count_nonzero(mask)

  # Compter le nombre total de pixels
  total_pixels = mask.size

  # Calculer le pourcentage de vert
  return (colored_pixels / total_pixels) * 100


def calculateScore(img):
  gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
  blurriness = np.var(cv2.Laplacian(gray, cv2.CV_64F))

  return blurriness


def detect_plant_name(imagePath):
  model_filename = 'mobilenet_v3_large_weights_best_acc.tar'
  filename = f"{modelsFolderAbsPath}/plantnet/{model_filename}" # pre-trained model path
  model = torch.load(filename, map_location='mps:0')
  
  mobilenet = mobilenet_v3_large(weights=model['model'], pretrained=True)
  preprocess = MobileNet_V3_Large_Weights.IMAGENET1K_V1.transforms
  
  decoded_image = decode_image(read_file(str(imagePath)))
  preprocessed = preprocess().forward(decoded_image)
  resultMatrix = mobilenet(preprocessed.unsqueeze(0)).squeeze(0).softmax(0)
  
  idxToSpecies = pd.read_json(f"{modelsFolderAbsPath}/plantnet/class_idx_to_species_id.json", typ='series')
  speciesToName = pd.read_json(f"{modelsFolderAbsPath}/plantnet/plantnet300K_species_id_2_name.json", typ='series')
  
  argmax = resultMatrix.argmax().item()
  speciesId = idxToSpecies.loc[argmax]
  speciesName = speciesToName.loc[speciesId]

  return speciesName
  

def detect_subject(image):
  # Charger l'image
  (h, w) = image.shape[:2]

  # Préparer l'image pour la détection d'objets
  blob = cv2.dnn.blobFromImage(
    image = cv2.resize(image, (bbox['x'], bbox['y'])),
    scalefactor=0.007843, 
    size = (bbox['x'], bbox['y']), 
    mean = 127.5
  )
  net.setInput(blob)
  detections = net.forward()

  # Parcourir les détections
  for i in range(detections.shape[2]):
    # Extraire la confiance (probabilité) associée à la détection
    confidence = detections[0, 0, i, 2]

    # Filtrer les détections faibles (seuil de confiance)
    if confidence > 0.5:  # Tu peux ajuster ce seuil si nécessaire
      # Extraire l'indice de la classe et calculer les coordonnées de la bounding box
      idx = int(detections[0, 0, i, 1])
      box = detections[0, 0, i, 3:7] * np.array([w, h, w, h])
      (startX, startY, endX, endY) = box.astype("int")
      
      return [startX, startY, endX, endY], idx
    
  return None, None
