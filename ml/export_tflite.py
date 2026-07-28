"""Export the trained Keras model as a fully-INT8 TensorFlow Lite asset."""
from __future__ import annotations

import argparse
import shutil
from pathlib import Path

import tensorflow as tf


def representative_dataset(dataset_dir: Path):
    dataset = tf.keras.utils.image_dataset_from_directory(
        dataset_dir, image_size=(224, 224), batch_size=1, shuffle=True, seed=42,
    )
    for images, _ in dataset.take(100):
        yield [tf.cast(images, tf.float32)]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--model', type=Path, required=True)
    parser.add_argument('--data', type=Path, required=True)
    parser.add_argument('--output', type=Path, required=True)
    args = parser.parse_args()
    trained_model = tf.keras.models.load_model(
        args.model,
        custom_objects={'preprocess_input': tf.keras.applications.mobilenet_v3.preprocess_input},
        safe_mode=False,
    )
    # Remove training-only augmentation and dropout before conversion. Retaining
    # random augmentation layers causes unsupported TFLite operations even when
    # exported in inference mode.
    trained_backbone = next(layer for layer in trained_model.layers if layer.name == 'MobileNetV3Small')
    trained_classifier = trained_model.layers[-1]
    # The training process uses mixed precision for speed. Recreate the
    # inference graph in float32 before calibration; full-INT8 conversion does
    # not accept the float16 operations retained by a mixed-precision graph.
    backbone = tf.keras.applications.MobileNetV3Small(
        input_shape=(224, 224, 3), include_top=False, weights=None,
    )
    backbone.set_weights([weight.astype('float32') for weight in trained_backbone.get_weights()])
    pooling = tf.keras.layers.GlobalAveragePooling2D()
    classifier = tf.keras.layers.Dense(4, activation='softmax', dtype='float32')
    inputs = tf.keras.Input(shape=(224, 224, 3), dtype=tf.float32, name='image')
    pooled = pooling(backbone(inputs, training=False))
    outputs = classifier(pooled)
    model = tf.keras.Model(inputs, outputs, name='vineguard_inference')
    classifier.set_weights([weight.astype('float32') for weight in trained_classifier.get_weights()])
    saved_model_dir = args.output.parent / 'exported_saved_model'
    if saved_model_dir.exists():
        shutil.rmtree(saved_model_dir)
    model.export(str(saved_model_dir))
    converter = tf.lite.TFLiteConverter.from_saved_model(str(saved_model_dir))
    converter.optimizations = [tf.lite.Optimize.DEFAULT]
    converter.representative_dataset = lambda: representative_dataset(args.data / 'train')
    converter.target_spec.supported_ops = [tf.lite.OpsSet.TFLITE_BUILTINS_INT8]
    converter.inference_input_type = tf.uint8
    converter.inference_output_type = tf.uint8
    args.output.write_bytes(converter.convert())
    print(f'Wrote {args.output} ({args.output.stat().st_size / 1024 / 1024:.2f} MB)')


if __name__ == '__main__':
    main()
