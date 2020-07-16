import nibabel as nib
import cv2


def nib_to_image():
    for path_in, path_out in zip(snakemake.input.images, snakemake.output.images):
        img = nib.load(path_in)
        img = img.get_fdata().astype(int)
        n = img.shape[2]
        img = cv2.normalize(img, None, 0, 255, cv2.NORM_MINMAX) # worse

        for i in range(n):
            slice = img[:, :, i]
            slice = cv2.normalize(slice, None, 0, 255, cv2.NORM_MINMAX)  # worse
            path = path_out + str(i) + '.png'
            cv2.imwrite(path, slice)  # problem
        # plt.imsave(path_out, img, format='jpeg', cmap='gray')


# TODO: make binary or 3 classes
def nib_to_mask():
    for path_in, path_out in zip(snakemake.input.masks, snakemake.output.masks):
        img = nib.load(path_in)
        img = img.get_fdata().astype(int)
        n = img.shape[2]
        for i in range(n):
            slice = img[:, :, i]
            path = path_out + str(i) + '.png'
            cv2.imwrite(path, slice)  # problem
        # plt.imsave(path_out, img, format='jpeg', cmap='gray')


def nib_to_image_and_mask():
    nib_to_image()
    nib_to_mask()


nib_to_image_and_mask()
