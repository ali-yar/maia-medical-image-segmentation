function [files] = parseDirectory(dir_, asString)

if ~exist('asString','var')
      asString = false;
end

data_list = dir(dir_);

files = cell(numel(data_list),1);

for i = 1:numel(files)
   files{i} = fullfile(data_list(i).folder,data_list(i).name);
end

if numel(files) == 1 && asString == true
    files = files{1};
end

end

