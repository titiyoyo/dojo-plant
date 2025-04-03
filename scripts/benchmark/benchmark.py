import imageprocessing as ip
import os, sys, pathlib as p
import pandas as pd
from mako.template import Template
from operator import itemgetter
from colorama import Fore, Style

# vars
imgSavePath = 'img'
reportFilesSavePath = 'out'
iterations = 20

try:
  path = sys.argv[1]
except IndexError:
  print('missing images path')   
  exit(1)

absPath = os.path.abspath(path)

if (os.path.exists(absPath) == False):
  print(f'Error: path {absPath} does not exist')
  exit(1)

jpgFiles = [(img, img.parent) for img in p.Path(path).rglob('*.jpg')]
jpegFiles = [(img, img.parent) for img in p.Path(path).rglob('*.jpeg')]

if len(jpgFiles) == 0 and len(jpegFiles) == 0:
  print(f'Error: no jpg or jpeg files found in {path}')
  exit(1)

if not os.path.exists(imgSavePath):
  os.makedirs(imgSavePath)

if not os.path.exists(reportFilesSavePath):
  os.makedirs(reportFilesSavePath)

print(Fore.CYAN)
print(f'>> Benchmarking {absPath}')
print(f'>> Finding all image files')
print(Style.RESET_ALL)

csvEntries = [ip.processImage(jpgFile, imgSavePath) for jpgFile in jpgFiles[:iterations]]
csvEntries.extend(ip.processImage(jpegFile, imgSavePath) for jpegFile in jpegFiles[:iterations])
csvEntries = sorted(csvEntries, key=itemgetter('blurriness'))

pd.DataFrame(csvEntries).to_csv(f"{reportFilesSavePath}/benchmark.csv", index=False)
mytemplate = Template(filename='template.html')

f = open(f"{reportFilesSavePath}/benchmark.html", "w")
f.write(mytemplate.render(data=csvEntries))
f.close()