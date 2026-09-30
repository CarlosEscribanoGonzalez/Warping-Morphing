## Overview
Three MATLAB scripts written to understand the fundamentals of image warping. Each script implements a different technique, making it possible to compare their behavior and see why some approaches work better than others.

## Forward warping

* Maps every source pixel to its position in the destination image
* Shows the main drawbacks of the method: holes (destination pixels that no source pixel lands on) and overlaps (several source pixels landing on the same destination pixel)
<p align = "center">
  <img width="256" height="256" alt="Forward" src="https://github.com/user-attachments/assets/ee23e24f-1277-4946-8412-2a6fbcb968fe" />
</p>

## Backward warping

* For every destination pixel, computes where it comes from in the source image and samples there
* Solves the problems of forward warping: no holes and exactly one value per destination pixel
* Interpolation can be used to get smoother results
<p align = "center">
  <img width="256" height="256" alt="Backward" src="https://github.com/user-attachments/assets/8a2b93f5-6598-49b6-a3c1-9854e4ca63eb" />
</p>

## Morphing

* Transforms one image into another using a parameter t between 0 and 1
* Interpolates the control points to obtain an intermediate geometry
* Applies backward warping to both images towards that geometry
* Cross-dissolves the two warped images to produce each frame
* Generates output GIFs in the `output` folder
<p align = "center">
  <img width="256" height="256" alt="morphed_warp" src="https://github.com/user-attachments/assets/0d7d528d-601c-4d60-94b7-d5943b314fa9" />
</p>

## What can be observed

* Forward warping leaves visible artifacts, especially when the transformation scales or rotates the region
* Backward warping produces clean results with the same transformation
* Morphing builds on backward warping, since a hole-free warp is required to blend both images correctly

## Usage

* Open the script you want to run in MATLAB
* Set the relative paths of the input images at the top of the script
* Run the script and select three points (a triangle) on each image, **in the same order** on both
* Wait until the program finishes
* In the morphing script, the resulting GIFs are saved in the `output` folder
