clc;clear all;
gt = dir("C:\Users\Herrera\OneDrive - International Islamic University Malaysia\Semester 3\Medical Image Segmentation and Applications\Labs\Lab 3\code\MISA\data\testing-set\testing-labels\*nii*");
res = dir("C:\Users\Herrera\OneDrive - International Islamic University Malaysia\Semester 3\Medical Image Segmentation and Applications\Labs\Lab 3\code\MISA\segmentation_results\*nii*");

for i = 1:numel(gt)
    groundTruth = double(niftiread(fullfile(gt(i).folder,gt(i).name)));
    segmentedImg = double(niftiread(fullfile(res(i).folder,res(i).name)));
    
    DICESCORE = dice(groundTruth(:),segmentedImg(:));
    
    disp([sprintf("test#%d:",i) DICESCORE']);
end
