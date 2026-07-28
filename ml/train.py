"""Train MobileNetV3Small and export a full INT8 TensorFlow Lite model."""
from __future__ import annotations
import argparse, json
from pathlib import Path
import tensorflow as tf

LABELS = ['Black_rot','Esca_(Black_Measles)','Leaf_blight_(Isariopsis_Leaf_Spot)','healthy']
def augment() -> tf.keras.Sequential:
    return tf.keras.Sequential([tf.keras.layers.RandomFlip('horizontal'), tf.keras.layers.RandomRotation(.12), tf.keras.layers.RandomContrast(.2), tf.keras.layers.RandomBrightness(.15)])
def dataset(path: Path, training: bool):
    return tf.keras.utils.image_dataset_from_directory(path, labels='inferred', class_names=LABELS, image_size=(224,224), batch_size=32, shuffle=training, seed=42).prefetch(tf.data.AUTOTUNE)
def main() -> None:
    p=argparse.ArgumentParser(); p.add_argument('--data',type=Path,required=True);p.add_argument('--output',type=Path,default=Path('artifacts'));p.add_argument('--epochs',type=int,default=25);a=p.parse_args(); a.output.mkdir(parents=True,exist_ok=True)
    tf.keras.mixed_precision.set_global_policy('mixed_float16')
    train,valid,test=(dataset(a.data/s, s=='train') for s in ('train','validation','test'))
    base=tf.keras.applications.MobileNetV3Small(input_shape=(224,224,3), include_top=False, weights='imagenet'); base.trainable=False
    model=tf.keras.Sequential([tf.keras.layers.Input((224, 224, 3)), augment(), tf.keras.layers.Lambda(tf.keras.applications.mobilenet_v3.preprocess_input), base, tf.keras.layers.GlobalAveragePooling2D(),tf.keras.layers.Dropout(.25),tf.keras.layers.Dense(4,activation='softmax',dtype='float32')])
    model.compile(optimizer=tf.keras.optimizers.Adam(1e-3),loss='sparse_categorical_crossentropy',metrics=['accuracy']); callbacks=[tf.keras.callbacks.ModelCheckpoint(a.output/'best.keras',save_best_only=True),tf.keras.callbacks.EarlyStopping(patience=5,restore_best_weights=True),tf.keras.callbacks.ReduceLROnPlateau(patience=2),tf.keras.callbacks.TensorBoard(a.output/'tensorboard')]
    model.fit(train,validation_data=valid,epochs=a.epochs,callbacks=callbacks); base.trainable=True
    for layer in base.layers[:-30]: layer.trainable=False
    model.compile(optimizer=tf.keras.optimizers.Adam(1e-5),loss='sparse_categorical_crossentropy',metrics=['accuracy']); model.fit(train,validation_data=valid,epochs=10,callbacks=callbacks)
    metrics=dict(zip(model.metrics_names, model.evaluate(test,return_dict=False))); (a.output/'metrics.json').write_text(json.dumps(metrics,indent=2)); model.save(a.output/'saved_model.keras')
    (a.output/'labels.txt').write_text('\n'.join(LABELS)+'\n')
if __name__=='__main__': main()
