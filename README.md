# VineGuard AI

An offline Android Flutter app for classifying grape leaf photos as Black rot, Esca, Leaf blight, or healthy. Images and history remain on-device. Treatment advice is educational and must be checked against local regulations and agricultural guidance.

## Run

Install Flutter stable and Android SDK, produce the reviewed model through [ML_PIPELINE.md](docs/ML_PIPELINE.md), copy both generated artifacts into `assets/ml/`, then run:

```powershell
flutter pub get
flutter analyze
flutter test
flutter build apk --release
```

The repository deliberately does not ship an unvalidated model binary. A release build requires a trained, evaluated `grape_disease_int8.tflite` with the matching labels file; this prevents pretending that random weights provide disease diagnosis.
