function [atlas] = buildProbabilisticAtlas(dataSet, labels)
% buildProbabilisticAtlas

shape = size(dataSet{1});

% how many labels
L = numel(labels);

% how many labeled volumes
N = numel(dataSet);

% instantiate an atlas of L volumes
atlas = cell(L,1);
for i = 1:L
    atlas{i} = zeros(shape);
end

% process one volume at a time
for i = 1:N
    D = dataSet{i};
    % start the tally for each label
    for j = 1:L
        idx = find(D == labels(j)); % indices of label j in volume i
        atlas{j}(idx) = atlas{j}(idx) + 1;
    end
end

% normalize the atlas to obtain values from 0 to 1
for i = 1:L
    atlas{i} = atlas{i} ./ N;
end

end