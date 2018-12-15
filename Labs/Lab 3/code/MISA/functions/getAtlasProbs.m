function Probs = ...
    getAtlasProbs(imgFile,atlasTempFile,atlasLabelFiles,paramFiles,mask,out_dir)

Probs = ones(sum(mask(:)),3);

% register atlas template to fixed image
command = 'elastix -f "%s" -m "%s" -out "%s" -p "%s" -p "%s"';
command = sprintf(command, imgFile, atlasTempFile, ...
    out_dir, paramFiles{1}, paramFiles{2});
system(command); 

% modify some lines in the transform param file
transfFname = "TransformParameters.1.txt";
transfFile = fullfile(out_dir,transfFname);
if ~exist(transfFile,'file') % if only 1 transform was generated
    transfFname = "TransformParameters.0.txt";
    transfFile = fullfile(out_dir,transfFname);
end
replaceLineInFile(transfFile,...
    '(FinalBSplineInterpolationOrder 3)', ...
    '(FinalBSplineInterpolationOrder 0)');
replaceLineInFile(transfFile, '(ResultImagePixelType "short")', ...
    '(ResultImagePixelType "float")');

% transform atlas labels
command = 'transformix -in "%s" -out "%s" -tp "%s"';
for i = 1:3
    cmd = sprintf(command,atlasLabelFiles{i},out_dir,transfFile);
    system(cmd); % about 32s
    res = niftiread(fullfile(out_dir,'result.nii'));
    % probabilities from registered atlas
    Probs(:,i) = res(mask); 
end

% clean
delete(fullfile(out_dir,"*.txt"));
delete(fullfile(out_dir,"*.log"));
delete(fullfile(out_dir,"result*.nii*"));

end

