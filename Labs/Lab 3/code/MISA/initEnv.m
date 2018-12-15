% clear
clear; close all; clc;

scripts_path = fullfile(pwd,'scripts');
functions_path = fullfile(pwd,'functions');
utilities_path = fullfile(pwd,'utilities');

% add folder(s) to search path
addpath(genpath(scripts_path),genpath(functions_path), ...
    genpath(utilities_path));