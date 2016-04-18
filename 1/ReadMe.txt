### Author: Sri Raghu Malireddi
The code is the submission for the Assignment 1 of the course Computational Photography.
The results can be checked in the ‘./results’ folder
The dataset used in the code can be accessed at ‘./dataset’ folder.

QUESTION:
1. Capture a normal image and noisy image of a scene. Add noise to the normal image so that it looks the same as the noisy image (Use PSNR to check).

2. Capture a normal image and a defocus blurred image of a planar scene. Blur the normal image so that it looks the same as the defocus blurred image (Use average gradient magnitude measure to check).

3. Capture a normal image and a motion blurred image of a dynamic scene. Blur the normal image so that it looks the same as the motion blurred image (Use average gradient magnitude measure to check).

RUN:
To run the code, add this folder to your path in MATLAB and run ‘submission.m’
Three figures will be generated with comparing the original and created versions.
The code is compatible to MATLAB versions R2014b or above.

Results:
The value of PSNR for the original noisy image is:9.1196
The value of PSNR for the generated noisy image is:7.8894
 
The value of average gradient magnitude measure for the original image is:4.2393
The value of average gradient magnitude measure for the original blurred image is:4.5526
The value of average gradient magnitude measure for the created blurred image is:0.78714

The value of average gradient magnitude measure for the original image is:2.3376
The value of average gradient magnitude measure for the original blurred image is:1.7945
The value of average gradient magnitude measure for the created blurred image is:0.68372


Acknowledgments:
The dataset has been created with the help of Sai Chowdary G’s toys and Sports shirt. Camera used for creating the dataset is 5MP, CarlZeiss Lens and for controlling the parameters of the Camera(such as ISO, shutter speed, Brightness, Focus) I used the Nokia Camera(an inbuilt app) for Microsoft phones.


