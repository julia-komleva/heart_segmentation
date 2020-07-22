import nibabel as nib
import cv2
import nibabel as nib
import cv2
import re
import numpy as np

def nib_to_image():
    for path_in, path_out in zip(snakemake.input.images, snakemake.output.images):
        img = nib.load(path_in)
        img = img.get_fdata().astype(int)
        n = img.shape[2]
        img = cv2.normalize(img, None, 0, 255, cv2.NORM_MINMAX) # worse
        i = int(re.sub('_', '', path_out[-6:-4]))
        slice = img[:, :, i]
        cv2.imwrite(path_out, slice)



# TODO: make binary or 3 classes
def nib_to_mask(preprocess):

    for path_in, path_out in zip(snakemake.input.masks, snakemake.output.masks):
        img = nib.load(path_in)
        img = img.get_fdata().astype(int)

        if preprocess:
            img = change_masks(img)

        n = img.shape[2]
        i = int(re.sub('_', '', path_out[-9:-7]))
        slice = img[:, :, i]
        cv2.imwrite(path_out, slice)


# rename masks to unite classes in different datasets
def change_masks(img, preprocess):
    if preprocess == 'nothing':
        return img
    elif preprocess == 'intersection': # unite classes
        if snakemake.params.dataset == 'emidec':
            img[img == 4] = 6 # no-reflow class
            img[img == 3] = 5 # myocardium infraction
            img[img == 2] = 4 # cavity
            img[img == 1] = 2 # myocardium (acdc class 2)
            return img
    elif preprocess == 'union':
        if snakemake.params.dataset == 'emidec':
            img[img == 4] = 8
            img[img == 3] = 7
            img[img == 2] = 6
            img[img == 1] = 5
            img[img == 0] = 4
            return img
def nib_to_image_and_mask(preprocess = 'union'):
    nib_to_image()
    nib_to_mask(preprocess)


nib_to_image_and_mask()




