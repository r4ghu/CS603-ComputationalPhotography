### Author: Sri Raghu Malireddi
The code is the submission for the Assignment 2 of the course Computational Photography.
The results can be checked in the ‘./results’ folder
The dataset used in the code can be accessed at ‘./dataset’ folder.

QUESTION:
1. Design a filter and adaptively restore an image corrupted by varying amounts of Gaussian Noise and Motion Blur.

2. Design a filter and adaptively restore an image corrupted by varying amounts of Gaussian Noise and Defocus Blur.

RUN:
To run the code, add this folder to your path in MATLAB and run ‘submission.m’
Two figures will be generated with comparing the original and created versions.
The code is compatible to MATLAB versions R2014b or above.

Results:
The first figure shows the image recovered from a motion blurred image with additive gaussian noise.
The second figure shows the image recovered from a defocus blurred image with defocus gaussian noise.
The ‘./results’ folder consists of images with varying gaussian noise.
Example: The image with name ‘Recovered_Noise_DefocusBlur_0.1_001.png’ is having a gaussian noise with 0.1 mean and 0.001 variance.

Acknowledgments:
The dataset has been created with the help of Sai Chowdary G’s toys and Sports shirt. Camera used for creating the dataset is 5MP, CarlZeiss Lens and for controlling the parameters of the Camera(such as ISO, shutter speed, Brightness, Focus) I used the Nokia Camera(an inbuilt app) for Microsoft phones.


