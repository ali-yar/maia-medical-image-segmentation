function [res] = expectation_maximization(x,mask)
%EXPECTATION_MAXIMIZATION

P_w1 = 0.30;
P_w2 = 0.41;
P_w3 = 0.29; 

idx = kmeans(x(mask),3);
data = x;
data(:,end+1) = 0;
data(mask,end) = idx; 

w1 = data(data(:,2)==1,1);
w2 = data(data(:,2)==2,1);
w3 = data(data(:,2)==3,1);

wt = [w1; w2; w3];

mu1 = mean(w1);
mu2 = mean(w2);
mu3 = mean(w3);

sigma1 = cov(w1);
sigma2 = cov(w2);
sigma3 = cov(w3);

sigma1 = 5;
sigma2 = 10;
sigma3 = 10;

for i=1:500
    P_x_w1 = exp(-(wt-mu1)/(2*sigma1^2)) / sqrt(2*pi*sigma1^2);
    P_x_w2 = exp(-(wt-mu2)/(2*sigma2^2)) / sqrt(2*pi*sigma2^2);
    P_x_w3 = exp(-(wt-mu3)/(2*sigma3^2)) / sqrt(2*pi*sigma3^2);


    P_w1_x = (P_x_w1 * P_w1) ./ (P_x_w1 * P_w1 + P_x_w2 * P_w2 + P_x_w3 * P_w3);
    P_w2_x = (P_x_w2 * P_w2) ./ (P_x_w1 * P_w1 + P_x_w2 * P_w2 + P_x_w3 * P_w3);
    P_w3_x = (P_x_w3 * P_w3) ./ (P_x_w1 * P_w1 + P_x_w2 * P_w2 + P_x_w3 * P_w3);

    mu1 = sum(P_w1_x .* wt) / sum(P_w1_x);
    mu2 = sum(P_w2_x .* wt) / sum(P_w2_x);
    mu3 = sum(P_w3_x .* wt) / sum(P_w3_x);

    sigma1 = sum(P_w1_x .* (wt-mu1).^2) / sum(P_w1_x);
    sigma2 = sum(P_w2_x .* (wt-mu2).^2) / sum(P_w2_x);
    sigma3 = sum(P_w3_x .* (wt-mu3).^2) / sum(P_w3_x);

    P_w1 = sum(P_w1_x) / numel(wt);
    P_w2 = sum(P_w2_x) / numel(wt);
    P_w3 = sum(P_w3_x) / numel(wt);

end

res = zeros(size(x));
res(mask) = idx;
end

