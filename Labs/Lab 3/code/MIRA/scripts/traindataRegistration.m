% parameters folder
param_dir = fullfile(pwd,"parameters");

% registration prameters file
paramFiles = {fullfile(param_dir,"params1.txt"), ...
    fullfile(param_dir,"params2.txt")};

% data folders
data_dir = "data/training-set/";
img_dir = fullfile(pwd,data_dir,"training-images/*.nii*");
label_dir = fullfile(pwd,data_dir,"training-labels/*.nii*");

% output
out_img_dir = fullfile(pwd,"registration_results","images");
out_label_dir = fullfile(pwd,"registration_results","labels");

% register intensity images
registerIntensityData(img_dir,paramFiles,param_dir,out_img_dir);

% transform label images
transformLabelData(label_dir,param_dir,out_label_dir);

% clean
delete(fullfile(out_label_dir,"*.log"));
delete(fullfile(out_img_dir,"*.log"));
delete(fullfile(out_img_dir,"*.txt"));




