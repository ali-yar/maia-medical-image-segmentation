% init environment
initEnv;

atlasType = "bspline1"; % choose a subfolder name under folder "./atlas"
saveSegmentedVolume = 0; % whether to save segmented nifti volumes

% select an option to run for segmentation
% Note: this generates a struct variable of probabilities and optionally
% creates segmented volumes. The probabilities are the ones used when
% computing the DICE index to speed up the process (see "main_dice.m").
segmentation_scenario = 3; % 1, 2, 3, 4 or 5

switch segmentation_scenario
    case 1 % segment from atlas only
        segmentWithAtlas;
    case 2 % segment from EM only
        segmentWithEM;
    case 3 % segment from atlas and EM
        segmentWithAtlasAndEM;
    case 4 % segment from tissue models only
        segmentWithTissueModels;
    case 5 % segment from atlas and tissue models
        segmentWithAtlasAndTissueModels;
end
