function [registeredLabels] = transformImages(files,param_dir,fileID,out_dir)

if ~exist(out_dir, 'dir')
   mkdir(out_dir);
end
% to make things easy, save the paths of the transformed labels
registeredLabels = cell(numel(files),1);

% transform the labels
for i = 1:numel(files)
    % id of the label
    labelID = getFileId(files{i});
    
    % find the transform parameters file
    param_file = fullfile(param_dir,sprintf("TransformParameters.%s.txt",fileID));
    
    % build and execute the command
    command = 'transformix -in "%s" -out "%s" -tp "%s"';
    command = sprintf(command, files{i}, out_dir, param_file);
    system(command);
    
    % rename the output file to be identified by the image number
    newName = fullfile(out_dir,sprintf('result.label%s.%s.nii.gz',labelID,fileID));
    movefile(fullfile(out_dir,'result.nii.gz'), newName);
    
    % add file path to list
    registeredLabels{i} = newName.char;
end

end

