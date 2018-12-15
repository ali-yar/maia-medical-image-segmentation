% data folders
data_dir = "data/testing-set";
img_dir = fullfile(pwd,data_dir,"testing-images","*.nii*");
mask_dir = fullfile(pwd,data_dir,"testing-mask","*.nii*");
gtruth_dir = fullfile(pwd,data_dir,"testing-labels","*.nii*");

% output folder
out_dir = fullfile(pwd,"segmentation_results","EM");
mkdir(out_dir); % create output folder if it does not exist

% parse data folders
img_files = parseDirectory(img_dir); % list of intensity image files
mask_files = parseDirectory(mask_dir); % list of mask files
gtruth_files = parseDirectory(gtruth_dir); % list of label (g-truth) files

% number of clusters/labels
k = 3;

% to save the probability matrices
probabilityEM = struct;

for i = 1:numel(img_files)
    img_filename = img_files{i};
    
    fileID = getFileId(img_filename);
    
    img = niftiread(img_filename); % intensity image
    mask_img = logical(niftiread(mask_files{i})); % mask image
    gtruth_img =  niftiread(gtruth_files{i}); % ground truth image

    % keep ROI only
    img = img .* mask_img;

    % segment
    [Probs, segmentedImg] = expect_max(img(:), mask_img(:), k);

    % match the label ordering with that of the ground truth
    [segmentedImg, newLabelOrder] = relabel(segmentedImg, gtruth_img);

    % obtain back the original volume shape
    segmentedImg = reshape(segmentedImg,size(img));
    
    % reorder the columns of the cluster probabilities matrix if needed
    if ~isequal(newLabelOrder,[1 2 3])
        Probs = Probs(:,newLabelOrder);
    end
    
    % save the probability matrix
    probabilityEM(i).id = fileID;
    probabilityEM(i).matrix = Probs;

    % write to file
    if saveSegmentedVolume == 1
        out_filename = sprintf("seg.%s.EM.nii",fileID);
        out_filename = fullfile(out_dir,out_filename);
        niftiwriteWrapper(segmentedImg,out_filename,img_filename,true);
    end
end

% write probability matrices to file
save(fullfile(out_dir,'probabilityEM'),'probabilityEM');
