// Test import of an asset
import catImage from '@/images/cat.jpg'
import '@tensorflow/tfjs-backend-webgl';
import '@tensorflow/tfjs-backend-cpu';
import * as tf from '@tensorflow/tfjs';

(async () => {
  const cat = document.createElement('img')
  cat.src = catImage

  const model = await tf.loadLayersModel('/models/mobilenet/export/model.json');
  const predictions = await model.predict(cat);

  const title = document.createElement('h3')
  title.innerHTML = "Predictions";

  const predictionsHTML = document.createElement('div')
  for (let i = 0; i < predictions.length; i++) {
    const p = document.createElement('p')
    p.innerHTML = `${predictions[i].className} - ${predictions[i].probability}`
    predictionsHTML.append(p)
  }

  const app = document.querySelector('#root')
  app.append(cat, title, predictionsHTML)
})()


