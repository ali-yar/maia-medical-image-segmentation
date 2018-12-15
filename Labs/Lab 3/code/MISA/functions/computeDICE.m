function dice_scores = computeDICE(sgmtData,gtruthData)

N = numel(sgmtData);

dice_scores = zeros(N,4);

for i = 1:N
    d = dice(sgmtData(i).labels,gtruthData(i).labels);
    dice_scores(i,1) = str2num(sgmtData(i).id);
    dice_scores(i,2:end) = round(d(1:3),3);
end

end

