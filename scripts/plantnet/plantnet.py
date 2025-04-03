from transformers import ViTImageProcessor, ViTForImageClassification
from PIL import Image
import requests
import json

url = '../../data/tw_clean/uncropped/pino_halepensis/0aec26372bb8102a694ab4d6d0515456.jpg'
image = Image.open(url)

processor = ViTImageProcessor.from_pretrained('janjibDEV/vit-plantnet300k')
model = ViTForImageClassification.from_pretrained('janjibDEV/vit-plantnet300k')
class_idx = json.load(open('class_idx_to_species_id.json'))
plant_names_idx = json.load(open('plantnet300K_species_id_2_name.json'))

inputs = processor(images=image, return_tensors="pt")
outputs = model(**inputs)
logits = outputs.logits

# model predicts one of the 1000 ImageNet classes
predicted_class_logits = logits.argmax(-1).item()
predicted_class_idx = model.config.id2label[predicted_class_logits]

species_idx = class_idx[str(predicted_class_idx)]
plant_name = plant_names_idx[species_idx]

print(f"results: {plant_name=}, {species_idx=}, {predicted_class_idx=}, {predicted_class_logits=}")