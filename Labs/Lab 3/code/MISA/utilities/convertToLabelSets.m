function DataLabels = convertToLabelSets(DataProbs)

DataLabels = struct;

for i = 1:numel(DataProbs)
    DataLabels(i).id = DataProbs(i).id;
    DataLabels(i).labels = label(DataProbs(i).matrix);
end

end

