function registerIntensityData(data_dir,param_files,param_dir,out_dir)

% create output directory if it does not exist
if ~exist(out_dir, 'dir')
   mkdir(out_dir);
end

% get list of files
files = parseDirectory(data_dir);

% set the 1st image as fixed image
fixed_img = files{1};

% copy the fixed image to output dir
copyfile(fixed_img,out_dir);

% register the rest of images to the fixed image
for i = 2:numel(files)
    % set the moving image
    moving_img = files{i};

    % id of the moving image
    id = getFileId(moving_img);
    
    % build and execute the elastics registration command
    command = 'elastix -f "%s" -m "%s" -out "%s" -p "%s" -p "%s"';
    command = sprintf(command,fixed_img,moving_img,out_dir,...
        param_files{1},param_files{2});
    system(command);
    
    % rename the output files to be identified by the image id
    rename(out_dir, id);
   
    % modify some lines in TranformParameters file
    pfile = fullfile(out_dir,sprintf('TransformParameters.%s.txt',id));
    oldLine = '(FinalBSplineInterpolationOrder 3)';
    newLine = '(FinalBSplineInterpolationOrder 0)';
    replaceLineInFile(pfile,oldLine,newLine);
    
    fNameOld = fullfile(out_dir,"TransformParameters.0.txt");
    fNameNew = fullfile(param_dir,sprintf("TransformParameters.%s.init.txt",id));
    oldLine = sprintf('(InitialTransformParametersFileName "%s")',fNameOld);
    newLine = sprintf('(InitialTransformParametersFileName "%s")',fNameNew);
    replaceLineInFile(pfile,oldLine,newLine);
    
    % move TranformParameters file to parameters folder
    movefile(pfile,param_dir);
    movefile(fullfile(out_dir,sprintf('TransformParameters.%s.init.txt',id)),param_dir);
end
    
end

