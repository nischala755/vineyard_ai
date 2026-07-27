"""Build a verified, de-duplicated grape-leaf dataset from source/class folders."""
from __future__ import annotations
import argparse, hashlib, json, shutil
from collections import Counter
from pathlib import Path
import cv2
from sklearn.model_selection import train_test_split

LABELS = {'black rot': 'Black_rot', 'black_rot': 'Black_rot', 'esca': 'Esca_(Black_Measles)', 'black measles': 'Esca_(Black_Measles)', 'leaf blight': 'Leaf_blight_(Isariopsis_Leaf_Spot)', 'isariopsis leaf spot': 'Leaf_blight_(Isariopsis_Leaf_Spot)', 'healthy': 'healthy'}
def normalise(name: str) -> str | None:
    key = name.lower().replace('-', ' ').replace('_', ' ').strip()
    return next((value for phrase, value in LABELS.items() if phrase in key), None)
def main() -> None:
    p = argparse.ArgumentParser(); p.add_argument('--sources', nargs='+', type=Path, required=True); p.add_argument('--output', type=Path, required=True); p.add_argument('--seed', type=int, default=42); args = p.parse_args()
    images, seen, skipped = [], set(), 0
    for source in args.sources:
        for file in source.rglob('*'):
            label = normalise(file.parent.name)
            if label is None or file.suffix.lower() not in {'.jpg','.jpeg','.png'}: continue
            data = file.read_bytes(); digest = hashlib.sha256(data).hexdigest()
            decoded = cv2.imdecode(__import__('numpy').frombuffer(data, __import__('numpy').uint8), cv2.IMREAD_COLOR)
            if digest in seen or decoded is None or min(decoded.shape[:2]) < 64: skipped += 1; continue
            seen.add(digest); images.append((file, label))
    if len({label for _, label in images}) != 4: raise ValueError('Expected all four normalized classes before splitting.')
    paths, labels = zip(*images); train, temp, train_y, temp_y = train_test_split(paths, labels, test_size=.30, stratify=labels, random_state=args.seed); valid, test, _, _ = train_test_split(temp, temp_y, test_size=.50, stratify=temp_y, random_state=args.seed)
    if args.output.exists(): shutil.rmtree(args.output)
    for split, files in {'train': train, 'validation': valid, 'test': test}.items():
        for index, source in enumerate(files):
            label = normalise(source.parent.name); target = args.output/split/label; target.mkdir(parents=True, exist_ok=True); shutil.copy2(source, target/f'{index:06d}_{source.name}')
    stats = {'accepted': len(images), 'skipped_duplicate_or_invalid': skipped, 'classes': Counter(labels), 'splits': {s: sum(1 for _ in (args.output/s).rglob('*') if _.is_file()) for s in ('train','validation','test')}}
    (args.output/'statistics.json').write_text(json.dumps(stats, indent=2)); print(json.dumps(stats, indent=2))
if __name__ == '__main__': main()
