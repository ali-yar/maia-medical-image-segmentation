% load probability matrices
load(fullfile(pwd,'segmentation_results','Atlas','probabilityAtlas'));
load(fullfile(pwd,'segmentation_results','EM','probabilityEM'));

data_dir = "data/testing-set";
mask_dir = fullfile(pwd,data_dir,"testing-mask","*.nii*");

% output folder
out_dir = fullfile(pwd,"segmentation_results","AtlasEM");
mkdir(out_dir); % create output folder if it does not exist

% init
probabilityAtlasEM = probabilityAtlas;

for i = 1:numel(probabilityAtlasEM)
    % combine corresponding probabilities from each source
    probabilityAtlasEM(i).matrix = ...
        probabilityAtlasEM(i).matrix .* probabilityEM(i).matrix;
end

% write probability matrices to file
save(fullfile(out_dir,'probabilityAtlasEM'),'probabilityAtlasEM');


% create segmented images
if saveSegmentedVolume == 1
    maskFiles = parseDirectory(mask_dir); % list of mask files

    for i = 1:numel(probabilityAtlasEM)
        maskImg = logical(niftiread(maskFiles{i})); % mask image

        % segment
        segmentedImg = zeros(size(maskImg));
        segmentedImg(maskImg) = label(probabilityAtlasEM(i).matrix);

        % write to file
        outFile = sprintf("seg.%s.atlasEM.nii",probabilityAtlasEM(i).id);
        outFile = fullfile(out_dir,outFile);
        niftiwriteWrapper(segmentedImg,outFile,maskFiles{i},true);
    end
end