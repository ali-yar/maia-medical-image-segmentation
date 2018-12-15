function [dataSet] = loadDataSet(data_list,isDouble,findPath)

if ~exist('isDouble','var')
    isDouble = false;
end

if ~exist('findPath','var')
    findPath = true;
end

dataSet = cell(numel(data_list),1);

for i = 1:numel(dataSet)
    if findPath == true
        file = fullfile(data_list(i).folder,data_list(i).name);
    else
        file = data_list{i};
    end
    
    dataSet{i} = niftiread(file);
    
    if isDouble == true
       dataSet{i} = double(dataSet{i});
    end
end

end

