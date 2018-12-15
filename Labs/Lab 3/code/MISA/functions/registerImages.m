function registerImages(fixedImg,movingImg,paramFiles,param_dir,out_dir)

if ~exist(out_dir, 'dir')
   mkdir(out_dir);
end

% id of the fixed image
id = getFileId(fixedImg);

% build and execute the elastics registration command
command = 'elastix -f "%s" -m "%s" -out "%s" -p "%s" -p "%s"';
command = sprintf(command, fixedImg, movingImg, out_dir, ...
    paramFiles{1}, paramFiles{2});
system(command);

% rename the output files to be identified by the image number
rename(out_dir, id);

% modify some lines in TranformParameters file
pfile = fullfile(out_dir,sprintf('TransformParameters.%s.txt',id));
if exist(pfile, 'file') % if rigid+non-rigid transforms were applied
    oldLine = '(FinalBSplineInterpolationOrder 3)';
    newLine = '(FinalBSplineInterpolationOrder 0)';
    replaceLineInFile(pfile,oldLine,newLine);

    oldLine = '(ResultImagePixelType "short")';
    newLine = '(ResultImagePixelType "float")';
    replaceLineInFile(pfile,oldLine,newLine);

    fNameOld = fullfile(out_dir,"TransformParameters.0.txt");
    fNameNew = fullfile(param_dir,sprintf("TransformParameters.%s.init.txt",id));
    oldLine = sprintf('(InitialTransformParametersFileName "%s")',fNameOld);
    newLine = sprintf('(InitialTransformParametersFileName "%s")',fNameNew);
    replaceLineInFile(pfile,oldLine,newLine);

    % move TranformParameters file to parameters folder
    movefile(pfile,param_dir);
    movefile(fullfile(out_dir,sprintf('TransformParameters.%s.init.txt',id)),param_dir);
else % if only rigid transform was applied (for some mysterious reason...)
    movefile(fullfile(out_dir,sprintf('TransformParameters.%s.init.txt',id)),pfile);
    
    oldLine = '(FinalBSplineInterpolationOrder 3)';
    newLine = '(FinalBSplineInterpolationOrder 0)';
    replaceLineInFile(pfile,oldLine,newLine);

    oldLine = '(ResultImagePixelType "short")';
    newLine = '(ResultImagePixelType "float")';
    replaceLineInFile(pfile,oldLine,newLine);

    % move TranformParameters file to parameters folder
    movefile(pfile,param_dir);
end

end

