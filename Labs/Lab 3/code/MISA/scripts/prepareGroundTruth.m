data_dir = fullfile(pwd,"data","testing-set");
label_dir = fullfile(data_dir,"testing-labels","*.nii*");
mask_dir = fullfile(data_dir,"testing-mask","*.nii*");

labelFiles = dir(label_dir);
maskFiles = dir(mask_dir);

labelData = loadDataSet(labelFiles,1);
maskData = loadDataSet(maskFiles,1);

gtruth = struct;
for i = 1:numel(labelData)
    gtruth(i).id = maskFiles(i).name(1:4);
    gtruth(i).labels = labelData{i}(logical(maskData{i}));
end

save(fullfile(pwd,'grdtruth.mat'),'gtruth');