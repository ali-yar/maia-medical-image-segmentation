% parameters folder
param_dir = fullfile(pwd,"parameters");
% atlas folder
atlas_dir = fullfile(pwd,"atlas",atlasType);
% testing set folders
data_dir = fullfile(pwd,"data","testing-set");
img_dir = fullfile(data_dir,"testing-images","*.nii*");
label_dir = fullfile(data_dir,"testing-labels","*.nii*");
mask_dir = fullfile(data_dir,"testing-mask","*.nii*");
% output folders
outImg_dir = fullfile(pwd,"registration_results","images");
outLabel_dir = fullfile(pwd,"registration_results","labels");
outSegm_dir = fullfile(pwd,"segmentation_results","Atlas");
% create output folder if it does not exist
mkdir(outSegm_dir); 

% registration prameters file
registParamFiles = {fullfile(param_dir,"params1.txt"), ...
    fullfile(param_dir,"params2.txt")};

% get atlas files from directory
atlasTemplateFile = parseDirectory(fullfile(atlas_dir,"*template*.nii*"),true);
atlasLabelFile = parseDirectory(fullfile(atlas_dir,"*label*.nii*"));

% get testing set from directory
imgFiles = parseDirectory(img_dir);
labelFiles = parseDirectory(label_dir);
maskFiles = parseDirectory(mask_dir);

% to save the probability matrices
probabilityAtlas = struct;

for i = 1:numel(imgFiles)  
    % set the fixed image
    fixedImg = imgFiles{i};
    fixedImg_id = getFileId(fixedImg);
    
    % register atlas template to fixed image
    registerImages(fixedImg,atlasTemplateFile, ...
        registParamFiles,param_dir,outImg_dir);
    
    % transform atlas label probabilities
    registeredAtlasLabels = ...
        transformImages(atlasLabelFile,param_dir,fixedImg_id,outLabel_dir);
    
    % segment
    [segmentedImg,Probs] = segmentImage(maskFiles{i},registeredAtlasLabels);
    
    % save the probability matrix
    probabilityAtlas(i).id = fixedImg_id;
    probabilityAtlas(i).matrix = Probs;
    
    % write to file
    if saveSegmentedVolume == 1
        out_filename = sprintf("seg.%s.atlas.nii",fixedImg_id);
        out_filename = fullfile(outSegm_dir,out_filename);
        niftiwriteWrapper(segmentedImg,out_filename,fixedImg,true);
    end

end

% write probability matrices to file
save(fullfile(outSegm_dir,'probabilityAtlas'),'probabilityAtlas');

% clean
delete(fullfile(outImg_dir,"*.txt"));
delete(fullfile(outImg_dir,"*.log"));
delete(fullfile(outLabel_dir,"*.log"));

