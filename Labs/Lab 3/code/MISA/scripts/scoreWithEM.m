gtruth_dir = fullfile(pwd,'data','testing-set','testing-labels','*.nii*');
sgmt_dir = fullfile(pwd,'segmentation_results','EM','*.nii*');

% where to store the scores
out_file = fullfile(pwd,'score_results/atlas_em.mat');

gtruthFiles = dir(gtruth_dir);
sgmtFiles = dir(sgmt_dir);

% gtruthFiles = gtruthFiles(1:2); sgmtFiles = sgmtFiles(1:2);

gtruthData = loadDataSet(gtruthFiles,1);
sgmtData = loadDataSet(sgmtFiles,1);

dice_scores = zeros(numel(sgmtData),4);

for i = 1:numel(sgmtData)
    d = dice(sgmtData{i}(:),gtruthData{i}(:));
    dice_scores(i,1) = str2num(getFileId(sgmtFiles(i).name));
    dice_scores(i,2:end) = round(d(1:3),3);
end

fprintf("IMG \t CSF \t WM \t GM\n");
for i = 1:numel(sgmtData)
    str = sprintf("%d \t %.3f \t %.3f \t %.3f",dice_scores(i,:));
    disp(str);
end

save(out_file,'dice_scores');