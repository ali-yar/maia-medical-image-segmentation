function labels = label(R)
%LABEL
% 
% Given N feature points and K clusters, assign feature points to the cluster
% which holds highest responsibility
% 
% Input:
%   R: NxK matrix
% Output:
%   labels: Nx1 vector with labels from 1 to K
% 

% find the max value in each row
max_value = max(R')';

% convert to one-hot  encoding
R = (R == max_value);

% initialize vector
labels = zeros(size(R,1),1);

% for every row (sample), the index of the column that has the value 1 in
% 'R' is the label
for k = 1:size(R,2)
    idx = boolean(R(:,k));
    labels(idx) = k;
end

end