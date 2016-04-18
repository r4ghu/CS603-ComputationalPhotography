### Author: Sri Raghu Malireddi
The code is the submission for the Assignment 10 of the course Computational Photography.
The results can be checked in the ‘./results’ folder
The dataset used in the code can be accessed at ‘./datasets’ folder.

QUESTION:
Given a set of multi-exposure images of a dynamic scene captured using a static camera, design an algorithm to generate the tone mapped HDR image of the scene without any ghosts.

RUN:
To run the code, add this folder to your path in MATLAB and run ‘submission.m’
The figures of the final HDR tone mapped image (with deghosting) of the given images is formed.
The code is compatible to MATLAB versions R2014b or above.

If you would like to generate results on your dataset, please change the directory name where you are keeping the images and their respective exposure times into the name_folder and exposure variables respectively.
For convenience, the generated results are placed in the './results' folder.

Results:
HDR image with deghosting of given LDR images.



Acknowledgments:
I would like to acknowledge credits for the algorithm:
Fabrizio Pece, and Jan Kautz.
Bitmap Movement Detection: HDR for Dynamic Scenes.
In Conference on Visual Media Production (CVMP), 2010

and the comparion image is taken from Mertens et al.