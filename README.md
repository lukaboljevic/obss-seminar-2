# 3D Marr-Hildreth edge detector

We implemented Marr-Hildreth's edge detection algorithm, to detect contours of human organs in 3D CT images from CT-MRI database (private database containing CT and MRI images from various patients).

For 3D detection to work, we first needed to implement the 2D version. The original algorithm is implemented in `marr.m`. The improved version, which incorporates the idea of strong and weak pixels (used in Canny's edge detection algorithm) for zero crossing detection, and edge linking using 8-connectivity, is implemented in `marrLinking.m`. Optionally, the resulting edges after linking can be thinned using morphological image processing (function `bwmorph` in MATLAB). The 2D version can be tested on any image from `images` folder. The parameters have to be set manually for each image.

The 3D version of Marr-Hildreth is implemented in `marr3D.m`. The idea is to apply the improved Marr-Hildreth algorithm on all head slices from `3D-images` or `3D-images-2` (the original slices are `0001.png`, `0002.png`, ..., `0211.png`), and then link consecutive slices together using 24-connectivity. Similarly to 2D case, the resulting edges in each slice can optionally be thinned using morphological image processing.


# Running the program

The 2D version can be ran from `run.m`, while the 3D version can be ran from `run3D.m`. Again, all parameters have to be set manually for each image (or set of images).
