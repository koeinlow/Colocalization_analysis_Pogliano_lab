%example script to run object_coloc_2d.m 
%written by Koe Inlow for Pogliano Labs at UCSD. 2023. 

img_1 = '20231108_Colocalization_ImagesforKoe/20231107_K2733_KZgp69mcherry_PA3gp108_KZgp104_113_162_sfGFP_KZ_0.2ara_10_R3D_w525.tif'; %green channel
img_2 = '20231108_Colocalization_ImagesforKoe/20231107_K2733_KZgp69mcherry_PA3gp108_KZgp104_113_162_sfGFP_KZ_0.2ara_10_R3D_w679.tif'; %red/magenta channel

dark_thres1 =33; %set the threshold level for the green channel
dark_thres2 =39; %set the threshold level for the red channel
nminpix = 4; %minimum number of pixels required for an object to be considered an object
nhood = 4; %number of neighboring connections for object detection. can be set to 4 or 8 for 2D images. 
nmaxpix = 150; %maximum number of pixels in an object to be considered an object 

[percent_OL, percent_obj_OL, tot_objs_OL, tot_objs2, N_pixels_OL, N_pixels_img2] = object_coloc_2d(img_1,img_2,dark_thres1,dark_thres2,nminpix,nhood, nmaxpix);
