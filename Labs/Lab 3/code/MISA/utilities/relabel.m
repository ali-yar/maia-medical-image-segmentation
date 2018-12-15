function [target, labelOrder] = relabel(target, reference)
%RELABEL
% 
% Make 2 images consistent in their labeling assignment.
% 
% Input:
%   target: image to swap its labels
%   reference: image whose label ordering is to follow
% Output:
%   target: image with labels swapped
%   labelOrder: keep track of which labels were swapped

labelOrder = [1 2 3]; % original label order

if ~isa(target,'double')
    target = double(target);
end
if ~isa(reference,'double')
    reference = double(reference);
end

target = target(:);
reference = reference(:);

% compute dice score
d = dice(target,reference);

% if only 2 labels are mismatching, swap them
if sum(d<0.5) == 2
    idx = find(d<0.5);
    target(target == idx(1)) = -1; % a temporary label
    target(target == idx(2)) = idx(1);
    target(target == -1) = idx(2);
    labelOrder(d<0.5) = idx([2 1]); % new label order
else

% if all 3 labels are mismatching, swap among all labels in 1 of the 2
% possible ways. Here the label order changes from [1 2 3] to [3 1 2]
if sum(d<0.5) == 3
    target(target == 1) = -1; % a temporary label
    target(target == 2) = 1;
    target(target == 3) = 2;
    target(target == -1) = 3;
    labelOrder = [3 1 2]; % new label order
end

% recompute dice
d = dice(target,reference);

% if still having mismatch, swap all again in the only left labeling order
% taking into account that the wanted order is [2 3 1] while the current 
% order is [3 1 2] (and not the initial [1 2 3])
if sum(d<0.5) == 3
    target(target == 3) = -1; % a temporary label
    target(target == 1) = 3;
    target(target == 2) = 1;
    target(target == -1) = 2;
    labelOrder = [2 3 1]; % new label order
end

end

end


