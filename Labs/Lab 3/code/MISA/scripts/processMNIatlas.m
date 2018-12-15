addpath(genpath(scripts_path));

atlas_dir = fullfile(pwd,'atlas','mni');

atlas = niftiread(fullfile(atlas_dir,"atlas.nii.gz"));

referenceImg = fullfile(atlas_dir,"template.nii.gz");

for i = 1:3
    labelImg = atlas(:,:,:,i+1);
    fname = sprintf("atlas_label%d",i);
    niftiwriteWrapper(labelImg, fname, referenceImg, true);
end

