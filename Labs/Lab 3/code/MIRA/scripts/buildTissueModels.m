% data folders
data_dir = "data/training-set/";
img_dir = fullfile(pwd,data_dir,"training-images","*.nii*");
label_dir = fullfile(pwd,data_dir,"training-labels","*.nii*");

% output folder
out_file = fullfile(pwd,'atlas','tissueModels');

% load volumes
IMGs = loadDataSet(dir(img_dir),false,true);
LBLs = loadDataSet(dir(label_dir),false,true);

IMGs = horzcat(IMGs{:});
LBLs = horzcat(LBLs{:});

IMGs = IMGs(:);
LBLs = LBLs(:);

% max intensity
maxVal = max(IMGs);

% total labeled pixels
total = sum(LBLs >0 & LBLs <4);

tissueModels = zeros(maxVal+1,3);
for i = 1:3
    idx = LBLs == i; % find indices where there is label i
    V = IMGs(idx); % get intensity values at those indices
    % compute and normalize
    tissueModels(:,i) = histcounts(V,(0:maxVal+1))/total; 
end

save(out_file,'tissueModels');

% plot
val = 2000;
figure;
title("Tissue models")
plot(0:val,tissueModels(1:val+1,1)); hold on;
plot(0:val,tissueModels(1:val+1,2));
plot(0:val,tissueModels(1:val+1,3)); hold off;
legend({'L1 (CSF)','L2 (WM)','L3 (GM)'});
