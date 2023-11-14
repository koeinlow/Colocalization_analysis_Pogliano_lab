function [percent_OL, percent_obj_OL, tot_objs_OL, tot_objs2, N_pixels_OL, N_pixels_img2 ] = object_coloc_2d(img_1,img_2,dark_thres1,dark_thres2,nminpix,nhood,nmaxpix)

%Script for measuring the percent colocalization of fluoresence (% of image 1 that is colocalized with image 2) 
%between two FOVs using object-based colocalization methods. This script takes two 8-bit TIFF images of
%equal dimensions and thresholds them either manually or automatically
%using <graythresh> and generate the corresponding label matrices.
%Refer to coloc_2d_ki to find the sum, mean, max, and min pixel intensity values of all objects.
%Written by Koe Inlow for the Pogliano Lab at UC San Diego. 11/2023.

%dark_thres1 and dark_thres2 = set to between 20-60, depending on the image resolution 
%nminpix = minimum number of pixels within an object to be considered a true object
%nhood = number of neighboring connections for object-detection. Can be set to 4 or 8 for 2D images. 

%% 
%load image 1
img__1 = double(imread(img_1)); 
%load image 2
img__2 = double(imread(img_2)); 
img1 = uint8(img__1 / 256); %convert both 16-bit images to 8-bit 
img2 = uint8(img__2 / 256);

%remove all pixels (to NaNs) which are darker than a specified threshold
img1 = img1(:,:,1) > dark_thres1;
img2 = img2(:,:,1) > dark_thres2;

%img2 = imtranslate(img2,[-1, -1.5]); %this is for drift correction in pixels, if drift between img1 and img2 are known.


%% Assume background is dark. Set dark_thres to find dark pixels. (usually between 20-50)
%backgroundMask1 = img1 < dark_thres1;
%backgroundMask2 = img2 < dark_thres2; 
% img1(backgroundMask1) = 0; % Set background to 0.
% img2(backgroundMask2) = 0;

figure(10)
imshow([img1, img2]); %show figure of side-by-side thresholded images 

img1a = zeros(size(img1)); 
img2a = zeros(size(img2));

img1a = bwareaopen(img1,nminpix,nhood); %remove objects with less than 4 pixels in 4-connected neighborhoods
img1a = bwpropfilt(img1a,'Area',[0 nmaxpix]); %remove objects that are larger than nmaxpix 
img1label = bwlabeln(img1a,nhood); %create object labels for the thresholded image 

img2a = bwareaopen(img2,nminpix,nhood);
img2a = bwpropfilt(img2a,'Area',[0 nmaxpix]);
img2label = bwlabeln(img2a,nhood);


C = imfuse(img1a,img2a,'Scaling','joint'); %overlay both thresholded images 
figure(45)
imshow(C) %show both images overlapped 

OL = (img1a&img2a);
OLlabel = bwlabeln(OL,nhood); % Find overlap using 4-connected neighborhoods

stats1 = regionprops (img1label,'Area','PixelList');  % to get object volume and pixel indexing
objs1 = [stats1.Area];
pixelList1 = {stats1.PixelList};
stats2 = regionprops (img2label,'Area','PixelList');
objs2 = [stats2.Area];
pixelList2 = {stats2.PixelList};
statsOL = regionprops (OLlabel,'Area','PixelList');
objsOL = [statsOL.Area];
pixelListOL = {statsOL.PixelList};

% Compute number and mean volume of objects in each image 
num_objs1 = length(objs1);                  % Number of objects in img1
mean_vol_objs_1 = mean(objs1);                   % Mean volume of objects in img1
num_objs2 = length(objs2);                  % Number of objects in img2
mean_vol_objs_2 = mean(objs2);                   % Mean volume of objects in img2
num_objs_OL = length(objsOL);                 % Number of objects in overlap image
mean_vol_objs_OLs = mean(objsOL);                 % Mean volume of objects in overlap image

% Compute fraction of objects that overlap
numOLp1 = num_objs_OL/num_objs1;                  % Number of overlap objects/number of objects in img1
numOLp2 = num_objs_OL/num_objs2;                  % Number of overlap objects/number of objects in img2

N_pixels_img1 = sum(cellfun('size',pixelList1,1));
N_pixels_img2 = sum(cellfun('size',pixelList2,1));
N_pixels_OL = sum(cellfun('size',pixelListOL,1));

percent_OL = N_pixels_OL/N_pixels_img2 
percent_obj_OL = numOLp2 
tot_objs_OL = num_objs_OL
tot_objs2 = num_objs2
N_pixels_img2 = N_pixels_img2
N_pixels_OL = N_pixels_OL
disp(percent_OL)
disp(percent_obj_OL)
end