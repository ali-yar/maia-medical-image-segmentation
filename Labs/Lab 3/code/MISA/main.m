% init environment
initEnv;

% Note: Results are saved in the folder "./Output"

% ***************************Choice Selection******************************
id = 1; % index of the test image (1->20), or put 0 to do all images
atlasType = "mni"; % bspline1 or mni (follows the subfolder name under "./atlas")
scenario = 1; % 1 -> Atlas+EM, 2 -> Atlas+TM, 3 -> Atlas only, 4 -> EM only   
saveResults = 0; % write DICE score to file
printResults = 1; % display DICE score in terminal
saveSegmentation = 1; % write segmented volume to file
% *************************************************************************

% *********************Setting directory paths*****************************
param_dir = fullfile(pwd,"parameters");
atlas_dir = fullfile(pwd,"atlas",atlasType);
% testing set folders
img_dir = fullfile(pwd,"data","testing-set","testing-images","*.nii*");
label_dir = fullfile(pwd,"data","testing-set","testing-labels","*.nii*");
mask_dir = fullfile(pwd,"data","testing-set","testing-mask","*.nii*");
% output folders
out_dir = fullfile(pwd,"Output");
% create output folder if it does not exist
mkdir(out_dir); 
% *************************************************************************

% *********************Reading directory paths*****************************
% get atlas files from directory
atlasTempFile = parseDirectory(fullfile(atlas_dir,"*template*.nii*"),true);
atlasLabelFiles = parseDirectory(fullfile(atlas_dir,"*label*.nii*"));
% get testing set from directory
imgFiles = parseDirectory(img_dir);
maskFiles = parseDirectory(mask_dir);
labelFiles = parseDirectory(label_dir);
% *************************************************************************

% registration prams files
paramFiles = { fullfile(param_dir,"params_2a.txt"), ...
    fullfile(param_dir,"params_2b.txt") };

% tissue models build from train data
load(fullfile(pwd,"atlas",'tissueModels.mat'));

dice_scores = zeros(numel(imgFiles),3);

tic; t = 0;
for idx = 1:numel(imgFiles)
    if id > 0
        idx = id;
    end
    
    % load image, mask and labels volumes
    img = niftiread(imgFiles{idx});
    mask = logical(niftiread(maskFiles{idx}));
    truth =  niftiread(labelFiles{idx});
    
    % remove non-labelled pixels
    truthROI = double(truth(mask));

    probsAtlas = ones(sum(mask(:)),3);
    probsEM = ones(sum(mask(:)),3);
    probsTM = ones(sum(mask(:)),3);
    
    t = t+1; exectime(t)= toc;
    
    %**********************Get Probs from Atlas****************************
    if ismember(scenario,[1,2,3]) % Atlas+{EM||TM} or Atlas only scenarios
        probsAtlas = getAtlasProbs(imgFiles{idx},atlasTempFile, ...
            atlasLabelFiles,paramFiles,mask,out_dir);
        t = t+1; exectime(t)= toc;  
    end
    %**********************************************************************

    %*************************Get Probs from EM****************************
    if ismember(scenario,[1,4]) % either Atlas+EM or EM only scenarios
        probsEM = getEMProbs(img(:), mask(:), 3); % about 5s
        t = t+1; exectime(t)= toc;
    end
    %**********************************************************************
    
    %*************************Get Probs from TM****************************
    if scenario == 2 % for the Atlas+TM scenario
        probsTM = getTMProbs(img, mask, tissueModels); %about 0.2s
        t = t+1; exectime(t)= toc;
    end
    %**********************************************************************

    % combine probabilities
    probsTotal = probsAtlas .* probsEM .* probsTM;
    % Note: both probsEM and probsTM are initialized with 1s.
    % Whatever scenario chosen, only one of the 2 at most will be non-1,
    % i.e. the probs from EM and TM will practically never be combined.

    % make hard assignment
    segmented = getSegmentation(probsTotal);
    t = t+1; exectime(t)= toc;

    % compute DICE
    d = dice(double(segmented),truthROI)';
    dice_scores(idx,:) = d(1:3);
    t = t+1; exectime(t)= toc;
    
    % generate segmented volume and write it to file
    if saveSegmentation ==1
        vol = single(mask);
        vol(mask) = segmented;
        filename = fullfile(out_dir, ...
            sprintf("segmented.%s.nii",getFileId(imgFiles{idx})));
        niftiwriteWrapper(vol, filename, imgFiles{idx}, 1);
        t = t+1; exectime(t)= toc;
    end
    
    if id > 0
        break;
    end
end

disp(exectime);

% save
if saveResults == 1
    switch scenario
        case 1, fname = "dice_AtlasEM";
        case 2, fname = "dice_AtlasTM";
        case 3, fname = "dice_Atlas";
        case 4, fname = "dice_EM";
        otherwise, fname = "dice";
    end
    save(fullfile(out_dir,fname),'dice_scores');
end

% print
if printResults == 1
    fprintf("IMG \t CSF \t WM \t GM\n");
    for i = 1:size(dice_scores,1)
        str = sprintf("%s \t %.3f \t %.3f \t %.3f", ...
            getFileId(imgFiles{i}),dice_scores(i,:));
        disp(str);
    end
end

