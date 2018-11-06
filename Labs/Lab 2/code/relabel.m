function [target] = relabel(target, reference)
%RELABEL
% 
% Make 2 images consistent in their labeling assignment.
% 
% Input:
%   target: image to swap its labels
%   reference: image whose label ordering is to follow
% Output:
%   target: image with labels swapped
% 

% compute dice score
d = dice(double(target(:)),double(reference(:)));

% if only 2 labels are mismatching, swap them
if sum(d<0.5) == 2
    idx = find(d<0.5);
    target(target == idx(1)) = 100; % a temporary label
    target(target == idx(2)) = idx(1);
    target(target == 100) = idx(2);
end

% if all 3 labels are mismatching, swap among all labels
if sum(d<0.5) == 3
    target(target == 1) = 100;
    target(target == 2) = 1;
    target(target == 3) = 2;
    target(target == 100) = 3;
end

% recompute dice
d = dice(double(target(:)),double(reference(:)));

% if still having mismatch, swap all again in the only left labeling order
if sum(d<0.5) == 3
    target(target == 3) = 100;
    target(target == 1) = 3;
    target(target == 2) = 1;
    target(target == 100) = 2;
end

% OLD - DISCARDED
% for i = 1:k
%     tmp = (groundTruth == i);
%     total(i) = sum(tmp(:));
% end
% [tmp, idx_gt] = sort(total);
% 
% for i = 1:k
%     tmp = (target == i);
%     total(i) = sum(tmp(:));
% end
% [tmp, idx_target] = sort(total);
% 
% for i = 1:k
%     target(target == idx_target(i)) = idx_gt(i)*10;
% end
% 
% target =  target / 10;
 
end


