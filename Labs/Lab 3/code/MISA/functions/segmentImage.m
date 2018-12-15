function [segmented, P] = segmentImage(maskFile, labels_list)
% segmented: volume image with labels
% P: Nx3 matrix of probabilities under each cluster

mask = logical(niftiread(maskFile));

segmented = zeros(size(mask));

labelData = loadDataSet(labels_list,true,false);

P = zeros(sum(mask(:)),3);

for i = 1:numel(labelData)
    % assign label i where there is highest probability
    idx = (labelData{i} >= 1/3); 
    segmented(idx) = i;
    % save the probabilities of cluster i in the matrix' column i
    P(:,i) = labelData{i}(mask);
end

segmented(~mask) = 0;

end




% function [segmented] = segmentImage(maskFile, labels_list)
% 
% labelData = loadDataSet(labels_list,true,false);
% 
% segmented = zeros(size(labelData{1}));
% 
% combinedLabels = zeros(size(labelData{1}));
% for i = 1:numel(labelData)
%     idx = (labelData{i} >= 1/3); 
%     combinedLabels(idx) = i;
% end
% 
% for z = 1:size(segmented,3)
%     for y = 1:size(segmented,1)
%         for x = 1:size(segmented,2)
%             if maskFile(y,x,z) == 1 
%                 segmented(y,x,z) = combinedLabels(y,x,z);
%             end
%         end
%     end
% end
% 
% end

% 
% function [segmented] = segmentImage(maskFile, labels_list)
% 
% labelData = loadDataSet(labels_list,true,false);
% 
% segmented = zeros(size(labelData{1}));
% 
% for i = 1:numel(labelData)
%     idx = (labelData{i} >= 1/3); 
%     segmented(idx) = i;
% end
% 
% 
% end




