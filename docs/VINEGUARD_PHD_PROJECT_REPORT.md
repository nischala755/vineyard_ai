# VineGuard AI — Project Status and Research Extension Brief

## 1. Project purpose

VineGuard AI is an offline Android application for preliminary grape-leaf disease screening. A user captures or selects a leaf image; an on-device TensorFlow Lite model classifies it as Black Rot, Esca (Black Measles), Leaf Blight, or Healthy. The app then presents prediction confidence, severity guidance, educational management advice, and an on-device history record.

The intended value is faster first-pass crop monitoring where network connectivity is limited. It is a decision-support prototype, not a replacement for a plant pathologist or locally approved pesticide guidance.

## 2. Work completed

### Mobile application

| Area | Completed implementation |
| --- | --- |
| Platform | Flutter Android application using Material 3 design |
| Image acquisition | Camera capture and gallery-image selection with permission handling |
| Image-quality protection | Basic dark-image and blur checks before classification |
| On-device AI | TensorFlow Lite inference; no image upload is required for prediction |
| Supported classes | Black Rot, Esca/Black Measles, Leaf Blight, Healthy |
| Results | Predicted label, confidence indicator, severity-oriented message, and crop-care guidance |
| History | Local SQLite scan history stored on the phone |
| User experience | Onboarding, persistent theme selection, bottom navigation, disease information, settings |
| Privacy | Images and scan history remain on device unless the user independently shares them |

### Machine-learning pipeline

| Item | Completed implementation |
| --- | --- |
| Base dataset | PlantVillage grape-leaf images, curated into the four supported classes |
| Dataset size | 4,062 labelled images: Black Rot 1,180; Esca 1,383; Leaf Blight 1,076; Healthy 423 |
| Data preparation | Corrupt-image filtering, duplicate checks, label normalisation, and stratified 70/15/15 train/validation/test split |
| Training model | Transfer-learned MobileNetV3 Small image classifier at 224 × 224 pixels |
| Mobile optimisation | Full-INT8 TensorFlow Lite conversion for low storage, RAM, and latency |
| Model size | 1.22 MB (`grape_disease_int8.tflite`) |
| Held-out test result | 98.36% accuracy on the PlantVillage held-out test split (610 images) |
| Reproducibility | Dataset preparation, training, conversion, and model-validation scripts are included in the repository |

## 3. Engineering verification completed

- Flutter static analysis: passed with no issues.
- Unit tests: passed (2 tests).
- TensorFlow Lite smoke test: passed; the exported model accepted a 224 × 224 RGB leaf image and returned the expected four-class output.
- Android release APK: built successfully.
- APK signing verification: passed using Android APK Signature Scheme v2.
- Source code and Android build configuration: pushed to the project GitHub repository.

## 4. Current deliverables

- Installable Android release APK for client/device testing.
- Flutter source code, Android project configuration, and automated checks.
- Offline INT8 TensorFlow Lite classifier and matching class-label asset.
- Dataset-preparation, training, conversion, and validation scripts.
- Technical ML pipeline notes.

## 5. Research interpretation and limitations

The 98.36% result is a strong internal benchmark, but it is measured on the held-out PlantVillage split. PlantVillage images are relatively clean and controlled. That value must not be presented as expected real-vineyard accuracy without a separate field evaluation.

Important current limitations:

1. The first model is a four-class classifier, not a complete catalogue of grape diseases, nutrient deficiencies, pests, or mixed infections.
2. The app currently evaluates a captured/selected image; it does not yet perform continuous live-video detection.
3. Confidence is a model score, not a clinical certainty estimate. It should be calibrated and evaluated under field conditions.
4. Treatment guidance is educational and requires local agronomist review before real agricultural use.
5. The APK is appropriate for direct testing. Publishing to Google Play requires an organisation-controlled release keystore and the relevant store compliance work.

## 6. High-value PhD extension roadmap

### Phase A — Field-data study (highest scientific value)

Collect a multi-site vineyard dataset covering cultivars, growth stages, seasons, phones, lighting, occlusion, leaf age, disease severity, and healthy look-alikes. Each image should receive expert confirmation, location/season metadata, and quality-control review.

Research outcomes:

- Demonstrate generalisation beyond laboratory-style imagery.
- Report per-class precision, recall, F1-score, confusion matrix, ROC/AUC where appropriate, and confidence intervals.
- Compare random-split evaluation with leave-one-vineyard-out and leave-one-season-out evaluation.
- Study bias by cultivar, device, lighting, and disease stage.

### Phase B — Stronger and more trustworthy AI

- Train and compare MobileNetV3, EfficientNet-Lite, MobileViT, and vision-transformer baselines under the same protocol.
- Add open-set/unknown-leaf detection so the app can say “not confidently supported” rather than forcing an incorrect class.
- Calibrate probabilities using temperature scaling or isotonic calibration; evaluate Expected Calibration Error and Brier score.
- Add explainability views such as Grad-CAM/Score-CAM to highlight regions that influenced a prediction.
- Experiment with severity grading (early, moderate, severe) and lesion segmentation rather than only disease presence.
- Use active learning: route low-confidence or disagreeing samples to an expert for annotation, then retrain periodically.

### Phase C — PhD-level data and multimodal contribution

- Combine leaf image data with weather, humidity, rainfall, temperature, growth stage, and vineyard location.
- Build a temporal risk-prediction model that forecasts disease pressure before visible symptoms become severe.
- Investigate federated learning or privacy-preserving continual learning across farms without centralising farmers’ images.
- Create a multilingual, human-centred evaluation with growers and agronomists: usability, trust, adoption barriers, and decision quality.
- Add geospatial dashboards and anonymised disease heatmaps for extension services, with informed consent and privacy safeguards.

### Phase D — Product maturity

- Real-time camera stream inference with frame sampling and temporal smoothing.
- Offline export of scan history as CSV/PDF and a structured treatment/follow-up diary.
- Background sync only when the user opts in, with encrypted storage and role-based web dashboard access.
- Accessibility improvements, local-language content, and agronomist-configurable regional guidance.
- Formal test plan across device tiers, battery/latency profiling, model monitoring, and Play Store release signing.

## 7. Suggested thesis contribution statement

“This work develops and evaluates a privacy-preserving, offline mobile decision-support system for grape-leaf disease screening. The research investigates robust field generalisation, calibrated uncertainty, explainable predictions, and multimodal early-risk forecasting across diverse vineyards.”

## 8. Suggested next milestone

The most defensible next milestone is a labelled, expert-verified field dataset and an external validation study. That turns the current functioning prototype into a research platform capable of producing publishable evidence about real-world performance.

## 9. Proposed next work I can deliver

The current deliverable is a working offline prototype. The following work packages can be commissioned independently or combined into a full PhD research platform.

| Work package | What I can deliver | Value to the research |
| --- | --- | --- |
| Field-data pipeline | Data-collection template, consent/metadata forms, image-quality rules, folder convention, de-duplication and annotation-preparation scripts | Produces a defensible, reusable research dataset rather than an unstructured photo collection |
| Expert annotation system | Web/mobile annotation workflow for disease class, severity, lesion region, expert reviewer, and disagreement resolution | Makes labels traceable and suitable for supervised learning and inter-rater analysis |
| Improved model study | Train and compare several mobile-friendly models; provide experiment configuration, test metrics, confusion matrices, and a reproducible report | Gives an evidence-based choice of model rather than relying on one accuracy score |
| Field-validation study | Evaluate the model on unseen vineyards/seasons/devices; calculate precision, recall, F1, calibration, confidence intervals, and failure cases | Establishes whether the system works in real conditions and supports a publishable methodology |
| Explainable AI | Add Grad-CAM/Score-CAM visual explanations and a clinician/agronomist review screen | Helps researchers inspect whether predictions use disease regions rather than background artefacts |
| Severity and lesion analysis | Develop disease-severity grades and/or lesion segmentation, including annotation schema and visual result overlays | Extends the work from “what disease?” to “how severe is it?” |
| Real-time scanning | Integrate live camera inference, frame sampling, temporal smoothing, low-confidence warnings, and on-device performance profiling | Makes the app more practical for vineyard walkthroughs |
| Weather-risk prediction | Combine disease observations with weather and vineyard metadata to model disease risk over time | Creates a novel early-warning research direction beyond image classification |
| Research dashboard | Build a secure dashboard for anonymised scans, trends, filtering, exports, and disease heatmaps | Supports analysis, supervision meetings, and presentation of research outcomes |
| Publication package | Prepare methodology diagrams, experiment tables, ablation-study templates, reproducibility checklist, and dissertation/technical-report figures | Converts the engineering work into material that can support a thesis or paper |

### Recommended order of work

1. **Field data and expert annotations:** establish valid data first; this is the most important dependency.
2. **External validation and model comparison:** quantify performance on genuinely unseen field data.
3. **Explainability and uncertainty handling:** make results trustworthy and inspectable.
4. **Severity analysis and real-time scanning:** improve practical utility.
5. **Weather-risk prediction and dashboard:** extend the project into a broader PhD contribution.

### Inputs required from the researcher

- Access to vineyards or collaborators who can collect representative field images.
- An agronomist/pathologist who can confirm disease labels and treatment content.
- Agreement on the target geography, grape varieties, diseases, and ethical/consent process.
- If weather or location modelling is desired, permission to use the selected data source and appropriate anonymisation rules.

### Immediate next deliverable I can start

I can next create the field-data collection and annotation package: a structured data schema, mobile/desktop collection instructions, metadata spreadsheet, annotation labels, quality checks, and retraining scripts. Once field images and expert labels are available, I can train and benchmark the next model version and integrate it into the app.
