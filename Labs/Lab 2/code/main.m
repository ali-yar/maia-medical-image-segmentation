clc; close all; clear all;

K = 3; % total clusters

outputFilename = "./segmented.nii";

% path to find the volume data
data_path = './P2_data/1/';
addpath(genpath(data_path));

% read data
groundTruth = niftiread('LabelsForTesting.nii');
t1 = niftiread('T1.nii');
t2 = niftiread('T2_FLAIR.nii');


% start timer
tic;

% if testing on 1 slice
% groundTruth = groundTruth(:,:,25);
% t1 = t1(:,:,25);
% t2 = t2(:,:,25);

mask_img = groundTruth > 0; % ignore background pixels
mask_img = double(mask_img);

% remove the skull contour
t1 = double(t1) .* mask_img; 
t2 = double(t2) .* mask_img;

% smooth the T2 FLAIR image
t2 = imgaussfilt(t2,2);

% build the feature vector (Nx2)
X = [t1(:), t2(:)]; 

% segment
label_img = expect_max(X, mask_img(:), K);

% match the label ordering with that of the ground truth
label_img = relabel(label_img, groundTruth);

% obtain back the original volume shape
label_img = reshape(label_img,size(groundTruth));

% stop timer
elapsed_time = toc;


% save the segmented volume into file
niftiwrite(label_img, outputFilename);

% compute the dice similarity result
dice_score = dice(double(label_img(:)),double(groundTruth(:)));
sum_dice_score = sum(dice_score);

str = sprintf('dice=(%.2f,%.2f,%.2f) - total_dice=%.2f - exec_time=%.0fs',... 
dice_score, sum_dice_score, elapsed_time);

disp(str);


% display a slice from the volume
figure;
subplot(2,2,1);
imshow(t1(:,:,25)',[]);
title("T1 ");
subplot(2,2,2);
imshow(t2(:,:,25)',[]);
title("T2 FLAIR ");
subplot(2,2,3);
imshow(label_img(:,:,25)',[]);
title("Segmented");
subplot(2,2,4);
imshow(groundTruth(:,:,25)',[]);
title("Ground Truth");

% figure;
% subplot(2,2,1);
% imshow(t1,[]);
% title("T1 ");
% subplot(2,2,2);
% imshow(t2,[]);
% title("T2 FLAIR ");
% subplot(2,2,3);
% imshow(label_img,[]);
% title("Segmented");
% subplot(2,2,4);
% imshow(groundTruth,[]);
% title("Ground Truth");