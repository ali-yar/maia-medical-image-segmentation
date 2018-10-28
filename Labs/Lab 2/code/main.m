clc; close all; clear all;

nifti_path = './NIfTI';
data_path = './P2_data/1/';

addpath(genpath(nifti_path));
addpath(genpath(data_path));

% reslice_nii('LabelsForTesting.nii', 'LabelsForTesting_.nii');
% reslice_nii('T1.nii', 'T1_.nii');
% reslice_nii('T2_FLAIR.nii', 'T2_FLAIR_.nii');

grounTruth = load_nii('LabelsForTesting_.nii');
t1 = load_nii('T1_.nii');
t2 = load_nii('T2_FLAIR_.nii');


gt_img = uint8(grounTruth.img(:,:,105));
mask_img = gt_img > 0;

img = t1.img(:,:,105);
img = img .* mask_img; % remove the skull contour

x = img(:); % feature vector
mask = mask_img(:);

idx = expectation_maximization(x, mask);

seg = reshape(idx,size(img));

figure;
imshow(img,[]);
figure;
imshow(seg,[]);
figure;
imshow(gt_img,[]);
