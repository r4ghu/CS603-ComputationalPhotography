### Author: Sri Raghu Malireddi
The code is the submission for the Assignment 3 of the course Computational Photography.
The results can be checked in the ‘./results’ folder
The dataset used in the code can be accessed at ‘./dataset’ folder.

QUESTION:
1. Perform image compression using SVD and validate using appropriate measure.

2. Establish correspondences between the corners detected in three images of the same scene captured from different view points.

RUN:
To run the code, add this folder to your path in MATLAB and run ‘submission.m’
Two figures will be generated with comparing the original and created versions.
The code is compatible to MATLAB versions R2014b or above.

Results:
The first figure shows the compressed image using SVD. The rank of the image reduced from 1728 to 50.
The second-fourth images show the correspondences of the corner features between the two images.(Left and Centre, Centre and Right, Left and Right respectively.

Acknowledgments:
The dataset has been created with the help of Sai Chowdary G’s toys and Visual Computing Lab’s MiniMacbeth Color Checker. Cameras used for creating the dataset is 5MP, CarlZeiss Lens and Kinect v2 and for controlling the parameters of the Camera(such as ISO, shutter speed, Brightness, Focus) I used the Nokia Camera(an inbuilt app) for Microsoft phones.


