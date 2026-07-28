class DiseaseProfile {
  const DiseaseProfile(
      {required this.id,
      required this.title,
      required this.description,
      required this.symptoms,
      required this.treatment,
      required this.organicTreatment,
      required this.prevention,
      required this.recovery});
  final String id,
      title,
      description,
      symptoms,
      treatment,
      organicTreatment,
      prevention,
      recovery;
}

const Map<String, DiseaseProfile> diseaseProfiles = {
  'Black_rot': DiseaseProfile(
      id: 'Black_rot',
      title: 'Black rot',
      description:
          'A fungal disease that can spread rapidly during warm, wet conditions.',
      symptoms:
          'Tan spots with dark borders; fruit may shrivel into black mummies.',
      treatment:
          'Remove infected material. Apply only locally approved fungicide according to label and agricultural-officer advice.',
      organicTreatment:
          'Improve canopy airflow; remove mummified fruit; use approved sulfur or copper products only where permitted.',
      prevention:
          'Prune for airflow, sanitize fallen leaves and avoid prolonged leaf wetness.',
      recovery:
          'Existing lesions do not heal; protect new growth and monitor weekly.'),
  'Esca_(Black_Measles)': DiseaseProfile(
      id: 'Esca_(Black_Measles)',
      title: 'Esca (black measles)',
      description:
          'A trunk-disease complex that can cause distinctive leaf striping.',
      symptoms:
          'Yellow/brown interveinal stripes, drying leaf margins and reduced vigour.',
      treatment:
          'Mark affected vines and seek local viticulture advice; prune affected wood in dry weather with disinfected tools.',
      organicTreatment:
          'Sanitize pruning tools between vines and remove severely affected wood responsibly.',
      prevention:
          'Avoid large pruning wounds, protect wounds where recommended, and maintain vine vigour.',
      recovery:
          'Recovery varies by trunk damage; repeated seasonal monitoring is essential.'),
  'Leaf_blight_(Isariopsis_Leaf_Spot)': DiseaseProfile(
      id: 'Leaf_blight_(Isariopsis_Leaf_Spot)',
      title: 'Leaf blight (Isariopsis leaf spot)',
      description: 'A foliar fungal disease encouraged by humid conditions.',
      symptoms: 'Irregular dark spots, yellowing and premature defoliation.',
      treatment:
          'Remove diseased leaves and follow a locally approved disease-management program.',
      organicTreatment:
          'Reduce humidity through canopy management and dispose of infected plant debris.',
      prevention:
          'Maintain spacing and airflow; inspect leaves after rain and irrigation.',
      recovery:
          'New protected foliage can remain healthy; continue scouting through the season.'),
  'healthy': DiseaseProfile(
      id: 'healthy',
      title: 'Healthy grape leaf',
      description:
          'No disease pattern was detected with sufficient confidence.',
      symptoms:
          'Leaf colour and texture appear consistent with a healthy leaf.',
      treatment: 'No treatment is indicated. Continue regular crop scouting.',
      organicTreatment:
          'Maintain balanced nutrition, irrigation and canopy airflow.',
      prevention: 'Inspect plants weekly and after prolonged wet weather.',
      recovery: 'Not applicable.'),
};
