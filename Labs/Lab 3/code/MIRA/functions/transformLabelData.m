function transformLabelData(data_dir,param_dir,out_dir)

% create output directory if it does not exist
if ~exist(out_dir, 'dir')
   mkdir(out_dir);
end

% get list of files
files = parseDirectory(data_dir);

% copy 1st file to output dir as it is reference (no transformation needed)
copyfile(files{1},out_dir);
    
% transform the rest of images given the corresponding transform parameters
for i = 2:numel(files)
    imgFile = files{i};

    % id of the image
    id = getFileId(imgFile);
    
    % find the transform parameters file
    paramFile = sprintf("%s/TransformParameters.%s.txt",param_dir,id);
    
    % build and execute the command
    command = 'transformix -in "%s" -out "%s" -tp "%s"';
    command = sprintf(command, imgFile, out_dir, paramFile);
    system(command);
    
    % rename the output file to be identified by the image number
    newName = fullfile(out_dir,sprintf('result.%s.nii.gz',id));
    movefile(fullfile(out_dir,'result.nii.gz'), newName);
    
    % compress image and delete the original (uncompressed) one
%     gzip(newName);
%     delete(newName);
end

end

