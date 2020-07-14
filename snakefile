configfile: "config.yaml"

import nibabel as nib
import cv2
import os

from helpers import get_patient_frame_pairs, get_frames

nums0, nums1, frames = glob_wildcards(config['acdc']['path_acdc'] + "/patient{num1}/patient{num2}_frame{frame}_gt.nii.gz")

pair_patient_frame = get_patient_frame_pairs(nums0)

# a pseudo-rule that collects the target files
rule all:
    input:
        expand(config['acdc']['path_processed'] + "/images/{pair[0]}_{pair[1]}.jpeg", pair = pair_patient_frame),
        expand(config['acdc']['path_processed'] + "/masks/{pair[0]}_{pair[1]}_gt.jpeg", pair = pair_patient_frame)


# a general rule using wildcards that does the work
rule acdc:
    input:
        images = expand(config['acdc']['path_acdc'] + "/patient{pair[0]}/patient{pair[0]}_frame{pair[1]}.nii.gz", pair = pair_patient_frame),
        masks = expand(config['acdc']['path_acdc'] + "/patient{pair[0]}/patient{pair[0]}_frame{pair[1]}_gt.nii.gz", pair = pair_patient_frame)
    output:
        images = expand(config['acdc']['path_processed'] + "/images/{pair[0]}_{pair[1]}.jpeg", pair = pair_patient_frame),
        masks = expand(config['acdc']['path_processed'] + "/masks/{pair[0]}_{pair[1]}_gt.jpeg", pair = pair_patient_frame)

    script:
        "scripts/scripts.py"



