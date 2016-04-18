### Author: Sri Raghu Malireddi
The code is the submission for the Assignment 6 of the course Computational Photography.
The results can be checked in the ‘./results’ folder
The dataset used in the code can be accessed at ‘./dataset’ folder.

QUESTION:
1. Develop a gradient domain HDR compression technique to compress the dynamic range of a given HDR image. Display the final tone mapped LDR image and evaluate its quality using dynamic range independent quality metric available online.

2. Develop an algorithm to perform matting from an image of a foreground captured with two different background colors (blue, green).


RUN:
To run the code, add this folder to your path in MATLAB and run ‘submission.m’
The figures of the posed questions will be generated
The code is compatible to MATLAB versions R2014b or above.

Results:
Metrics are calculated and kept in the results folder(there is some problem with the website, showing the same error even when I use the original HDR output from paper)

Note: For testing with .exr format images, please use the openexr-matlab codes for exrread function.


Acknowledgments:
The dataset is taken with the help Sai Ramana Reddy. I would like to acknowledge that some part of the implementation ‘Poisson Neumann’ has been understood and implemented from Amit Agrawal’s 2004 work. And the algorithms for writing the codes are taken from their respective standard papers


