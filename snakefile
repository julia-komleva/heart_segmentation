#https://github.com/KonstantinUshenin/urfu_bioinf_2020/blob/master/Snakefile
config: "config.json"

import nibabel as nib
import cv2

def get_frames(patient_num):
    res = os.listdir('/home/euloo/Documents/datasets/acdc/patient{}'.format(patient_num))
    res = filter(lambda x: x.endswith('_gt.nii.gz'), res)
    res = map(lambda x: x.split('_')[1].replace('frame', ''), res)
    res = list(res)
    return res

def get_patient_frame_pairs(patients):
    pair_patient_frame = []
    for patient in set(patients): # duplicates bug
        frames = get_frames(patient)
        for frame in frames:
            pair_patient_frame.append((patient, frame))
    return pair_patient_frame


nums0, nums1, frames = glob_wildcards("/home/euloo/Documents/datasets/acdc/patient{num1}/patient{num2}_frame{frame}_gt.nii.gz")


pair_patient_frame = get_patient_frame_pairs(nums0)
#print(pair_patient_frame)

# a pseudo-rule that collects the target files
rule all:
    input:
        expand("/home/euloo/Documents/GitHub/heart/data/images/{pair[0]}_{pair[1]}.jpeg", pair = pair_patient_frame),
        expand("/home/euloo/Documents/GitHub/heart/data/masks/{pair[0]}_{pair[1]}_gt.jpeg", pair = pair_patient_frame)

# a general rule using wildcards that does the work
rule acdc:
    input:
        images = expand("/home/euloo/Documents/datasets/acdc/patient{pair[0]}/patient{pair[0]}_frame{pair[1]}.nii.gz", pair = pair_patient_frame),
        masks = expand("/home/euloo/Documents/datasets/acdc/patient{pair[0]}/patient{pair[0]}_frame{pair[1]}_gt.nii.gz", pair = pair_patient_frame)
    output:
        images = expand("/home/euloo/Documents/GitHub/heart/data/images/{pair[0]}_{pair[1]}.jpeg", pair = pair_patient_frame),
        masks = expand("/home/euloo/Documents/GitHub/heart/data/masks/{pair[0]}_{pair[1]}_gt.jpeg", pair = pair_patient_frame)

    #script:
    #    "scripts/imshow.py"
    run:
        for path, path2 in zip(input.images, output.images):
            img = nib.load(path)
            img = img.get_fdata()
            img = img[:,:,0]
            cv2.imwrite(path2, img)

        # TODO: make binary or 3 classes
        for path, path2 in zip(input.masks, output.masks):
            img = nib.load(path)
            img = img.get_fdata()
            img = img[:,:,0]
            cv2.imwrite(path2, img)


