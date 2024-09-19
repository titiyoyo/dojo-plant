import cv2
import numpy as np

def calculateBrightness(img):
  hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
  avg = np.mean(hsv[:,:, 2])
  per = (avg/255)*100

  return per


def drawRectangle(img, centerX, centerY):
  start_point = (centerX-centerX//2, centerY+centerY//2)
  end_point = (centerX+centerX//2, centerY-centerY//2)
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
