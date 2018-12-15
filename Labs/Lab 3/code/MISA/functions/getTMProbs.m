function Probs = getTMProbs(img, mask, tissueModels)

intensities = img(mask(:)) + 1; % add 1 since the tissueModels starts with intensity 0

Probs = zeros(numel(intensities),3);

for i = 1:size(tissueModels,2)
    Probs(:,i) = tissueModels(intensities,i);
end

% when there is a 0 under every cluster for the same intensity value,
% change to 1 so that the contribution from TM for that value is neutral.
s = sum(Probs,2);
idx = s == 3;
Probs(idx,:) = ones(sum(idx),3);

end

