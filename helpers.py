# config: "config.yaml"

import yaml
import os

file = open('config.yaml', 'r')
config = yaml.load(file, Loader=yaml.FullLoader)

def get_frames(patient_num):
    path_acdc = config['acdc']['path_acdc']
    path_acdc = os.path.join(path_acdc, 'patient')
    # res = os.listdir('/home/euloo/Documents/datasets/acdc/patient{}'.format(patient_num))
    res = os.listdir(path_acdc + str(patient_num))
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

