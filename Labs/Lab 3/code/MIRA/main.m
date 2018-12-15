% clear
clear; close all; clc;

% functions folder
scripts_path = fullfile(pwd,'scripts');
functions_path = fullfile(pwd,'functions');
utilities_path = fullfile(pwd,'utilities');

% add folder(s) to search path
addpath(genpath(scripts_path),genpath(functions_path), ...
    genpath(utilities_path));

% select an option to run
scenario = 3; % 1, 2, 3 or 4

switch scenario
    case 1 % register train data (intensity and label volumes)
        traindataRegistration;
    case 2 % build intensity template
        atlasTemplate;
    case 3 % build label probabilities
        atlasProbabilities;
    case 4 % build probabilistic tissue models
        buildTissueModels;
end
