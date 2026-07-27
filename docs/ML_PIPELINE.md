# ML pipeline

The production classifier is MobileNetV3Small at 224px. It is selected over EfficientNet-B0/V2-B0 and ConvNeXt-Tiny because it provides the best latency, RAM and battery profile on low- and mid-range Android devices while retaining strong transfer-learning accuracy. The output contract is four classes, in the exact order in `assets/ml/labels.txt`.

Dataset sources should combine PlantVillage grape classes with field-image datasets only after licence review. PlantVillage gives clean, class-balanced disease labels; field sets introduce lighting, background, camera and severity variation. Do not merge examples with incompatible labels or licences.

```powershell
python -m venv .venv; .\.venv\Scripts\pip install -r ml\requirements.txt
python ml\prepare_dataset.py --sources D:\datasets\PlantVillage D:\datasets\field-grapes --output data\processed
python ml\train.py --data data\processed --output artifacts
Copy-Item artifacts\grape_disease_int8.tflite assets\ml\
Copy-Item artifacts\labels.txt assets\ml\
```

`prepare_dataset.py` rejects corrupt/small images, SHA-256 duplicate files, normalizes known names, creates stratified 70/15/15 splits, and writes statistics. Extend its label map only with reviewed taxonomy. `augmentations.py` defines the Albumentations vineyard policy (brightness/contrast, CLAHE, noise, blur, shadow, rotation, perspective, hue/saturation, crop, flip and normalization). Training includes early stopping, checkpointing, LR reduction, TensorBoard and full-INT8 conversion.
