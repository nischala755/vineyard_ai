"""Albumentations policy used for field-image training experiments."""
import albumentations as A

def vineyard_augmentations(size: int = 224) -> A.Compose:
    return A.Compose([
        A.RandomBrightnessContrast(brightness_limit=.20, contrast_limit=.20, p=.7), A.CLAHE(p=.25),
        A.GaussNoise(var_limit=(5., 35.), p=.25), A.MotionBlur(blur_limit=5, p=.2), A.RandomShadow(p=.25),
        A.Rotate(limit=20, border_mode=0, p=.5), A.Perspective(scale=(.03, .10), p=.25),
        A.HueSaturationValue(hue_shift_limit=12, sat_shift_limit=20, val_shift_limit=12, p=.5),
        A.HorizontalFlip(p=.5), A.RandomResizedCrop(size=size, width=size, scale=(.75, 1.0), p=1),
        A.Normalize(),
    ])
