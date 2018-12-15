% init environment
initEnv;

% select an option to run for DICE index computation (see details below)
scenario = 1; % 1, 2, 3, 4 or 5

sgmntDir = fullfile(pwd,'segmentation_results');
outDir = fullfile(pwd,'score_results');

% load simplified ground-truth data, or generate it if it does not exist
try
    load('gtruth.mat');
catch
    prepareGroundTruth;
end

switch scenario
    case 1 % score from Atlas only
        load(fullfile(sgmntDir,'Atlas','probabilityAtlas.mat'));
        segmentation = convertToLabelSets(probabilityAtlas);
        outputFile = fullfile(outDir,"diceAtlas.mat");
    case 2 % score from EM only
        load(fullfile(sgmntDir,'EM','probabilityEM.mat'));
        segmentation = convertToLabelSets(probabilityEM);
        outputFile = fullfile(outDir,"diceEM.mat");
    case 3 % score from Atlas and EM
        load(fullfile(sgmntDir,'AtlasEM','probabilityAtlasEM.mat'));
        segmentation = convertToLabelSets(probabilityAtlasEM);
        outputFile = fullfile(outDir,"diceAtlasEM.mat");
%     case 3 % segment from tissue models only
%         scoreWithTissueModels;
%     case 4 % segment from atlas and tissue models
%         scoreWithAtlasAndTissueModels;
%     case 5 % segment from atlas and EM
%         scoreWithAtlasAndEM;
end

dice_scores = computeDICE(segmentation,gtruth);

% save
save(outputFile,'dice_scores');

% print
fprintf("IMG \t CSF \t WM \t GM\n");
for i = 1:size(dice_scores,1)
    str = sprintf("%d \t %.3f \t %.3f \t %.3f",dice_scores(i,:));
    disp(str);
end
