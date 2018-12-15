% data folders
data_dir = "data/testing-set";
img_dir = fullfile(pwd,data_dir,"testing-images","*.nii*");
mask_dir = fullfile(pwd,data_dir,"testing-mask","*.nii*");

% tissueModels: cluster probabilities for each intensity value
load(fullfile(pwd,'atlas','tissueModels.mat'));

% output folder
out_dir = fullfile(pwd,"segmentation_results","TissueModels");
mkdir(out_dir); % create output folder if it does not exist

% parse data folders
img_files = parseDirectory(img_dir); % list of intensity image files
mask_files = parseDirectory(mask_dir); % list of mask files

% min and max intensity values in the tissue models
minVal = find(tissueModels(:,1)>0); % from CSF
minVal = minVal(1)-1;
maxVal = find(tissueModels(:,2)>0); % from GM
maxVal = maxVal(end)-1;

for i = 1:numel(img_files)
    img_filename = img_files{i};
    
    fileID = getFileId(img_filename);
    
    img = niftiread(img_filename); % intensity image
    mask_img = logical(niftiread(mask_files{i})); % mask image
    
    % keep ROI only
    img = img .* mask_img;

    % initialize segmented image
    segmentedImg = zeros(size(img));
    
    for j = minVal:maxVal
        [~,lbl] = max(tissueModels(j+1,:));
        segmentedImg(img==j) = lbl;
    end
    
    % assign labels when there is no info from tissue models
    segmentedImg(img<minVal) = 1; % assign label 1 (CSF) to pixels < minVal
    segmentedImg(img>maxVal) = 2; % assign label 2 (GM) to pixels > maxVal

    % write to file
    out_filename = sprintf("seg.%s.TM.nii",fileID);
    out_filename = fullfile(out_dir,out_filename);
    niftiwriteWrapper(segmentedImg,out_filename,img_filename,true);
end