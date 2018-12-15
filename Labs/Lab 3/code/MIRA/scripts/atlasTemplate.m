% input dir
in_dir = fullfile(pwd,"registration_results","images","*.nii*");

% output dir
out_dir = fullfile(pwd,"atlas");

% get list of volumes from directory
data_list = dir(in_dir);

% load volumes
dataSet = loadDataSet(data_list,true);

% initialize the mean volume with first volume
mean_volume = dataSet{1};

for i = 2:numel(dataSet)
    mean_volume = mean_volume + dataSet{i};
end

mean_volume = mean_volume ./ numel(dataSet);

out_filename = fullfile(out_dir,"atlas_template");
vol_reference = fullfile(data_list(1).folder,data_list(1).name);
niftiwriteWrapper(mean_volume, out_filename, vol_reference, true);
