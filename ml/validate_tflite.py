"""Smoke-test the exported model against a held-out image."""
from __future__ import annotations
import argparse
from pathlib import Path
import numpy as np
import tensorflow as tf

def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--model', type=Path, required=True)
    parser.add_argument('--image', type=Path, required=True)
    args = parser.parse_args()
    interpreter = tf.lite.Interpreter(model_path=str(args.model)); interpreter.allocate_tensors()
    input_detail, output_detail = interpreter.get_input_details()[0], interpreter.get_output_details()[0]
    image = tf.io.decode_image(args.image.read_bytes(), channels=3, expand_animations=False)
    image = tf.image.resize(image, (224, 224)).numpy().astype(np.uint8)[None, ...]
    interpreter.set_tensor(input_detail['index'], image); interpreter.invoke()
    output = interpreter.get_tensor(output_detail['index'])[0]
    print({'input': str(input_detail['dtype']), 'output': str(output_detail['dtype']), 'class': int(np.argmax(output)), 'confidence': float(output.max()) / 255.0})

if __name__ == '__main__': main()
