% input dir
in_dir = fullfile(pwd,"registration_results","labels","*.nii*");

% output dir
out_dir = fullfile(pwd,"atlas");

% output file(s)
out_filename_tmplt = fullfile(out_dir,"atlas_label_");

% get list of labeled volumes from directory
data_list = dir(in_dir);

% the label values looked for
labels = [1,2,3];

% load labeled volumes
labeledSet = loadDataSet(data_list,true);

% build the atlas' probabilistic labels
atlas = buildProbabilisticAtlas(labeledSet, labels);

% write volumes to file
vol_reference = fullfile(data_list(1).folder,data_list(1).name);
saveAtlasLabels(atlas,labels,out_filename_tmplt,vol_reference,true);
