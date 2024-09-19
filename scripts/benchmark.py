import imageprocessing as ip
import os, sys, pathlib as p
import cv2
import numpy as np
import pandas as pd
from mako.template import Template
from operator import itemgetter

savePath = 'img'

def processImage(file):
  head, tail = os.path.split(file)
  processedImagePath = f"{savePath}/{tail}"

  img = cv2.imread(file)
  h, w, c = img.shape
  centerY, centerX = h // 2, w // 2
  crop_img = img[centerX-(centerX//2):centerX+(centerX//2), centerY-(centerY//2):centerY+(centerY//2)]

  blurriness = ip.calculateScore(crop_img)
  imgWithRectangle = ip.drawRectangle(img, centerX, centerY)
  greenPercentage = ip.calculateGreen(crop_img)
  brownPercentage = ip.calculateBrown(crop_img)
  brightness = ip.calculateBrightness(crop_img)

  cv2.imwrite(processedImagePath, imgWithRectangle)

  return {
    'green': greenPercentage,
    'brown': brownPercentage,
    'blurriness': blurriness, 
    'brightness': brightness, 
    'file': processedImagePath
  }


path = sys.argv[1]
absPath = os.path.abspath(path)

if (os.path.exists(absPath) == False):
  print(f'Error: path {absPath} does not exist')
  exit(1)

print(f'>> Benchmarking {absPath}')
print(f'>> Finding all image files')

jpgFiles = list(p.Path(path).rglob('*.jpg'))
jpegFiles = list(p.Path(path).rglob('*.jpeg'))

csvEntries = [processImage(jpgFile) for jpgFile in jpgFiles[:100]]
csvEntries.extend(processImage(jpegFile) for jpegFile in jpegFiles[:100])

csvEntries = sorted(csvEntries, key=itemgetter('blurriness'))


pd.DataFrame(csvEntries).to_csv('benchmark.csv', index=False)

mytemplate = Template(filename='template.html')

f = open("benchmark.html", "w")
f.write(mytemplate.render(data=csvEntries))
f.close()