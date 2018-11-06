function [labels] = expect_max(X,mask,K)
%EXPECT_MAX
% 
% Iterate between a series of expectation and maximization, trying to 
% find the best parameters of the probability densities that models the
% data.
% 
% Input:
%   X: Nx2 feature vector
%   mask: binary vector to be applied on X to ignore non-ROI feature points
%   K: total clusters
% Output:
%   labels: Nx1 vector with numerically labeled elements
% 

% max number of iterations of the E-M steps
max_iters = 10;

% indices of non-zero pixels
roi_idx = find(mask>0);

% keep only non-zero pixels
X = X(roi_idx,:);



total_pts = size(X,1);

% k-means to get initial centroids
[tmp, centers] = kmeans(X,K);
c1 = X(tmp == 1,:);
c2 = X(tmp == 2,:);
c3 = X(tmp == 3,:);

U = centers; % centroids of clusters / means of the Gaussians
COV = {cov(c1) cov(c2) cov(c3)}; % spread of the clusters / covariance of the Gaussians
P = [1/3 1/3 1/3]; % weights / prior probabilities of clusters

% figure,
% plot (X(:,1),X(:,2),'.g');
% hold on;
% plot(U(:,1),U(:,2),'.r');
% title("Initial");

old_log_likelihood = -100;

for count = 1:max_iters
   
    % ********************* E-step *********************

    % init
    pdf_x_weighted = zeros(total_pts,K);
    R = zeros(total_pts,K);
    
    % the likelihood of each sample in the distribution of a cluster (P_xi|wj)
    for k = 1:size(U,1)
        pdf = mvnpdf(X,U(k,:),COV{k}); % the PDF of cluster k at each sample
        pdf_x_weighted(:,k) = pdf * P(k); % scale by the cluster weight
    end
    % responsability matrix (rows are data points, cols are clusters)
    for k = 1:size(U,1)
        R(:,k) = pdf_x_weighted(:,k) ./ sum(pdf_x_weighted,2);
    end

    %    ***** SLOW VERSION - DISCARDED *****
%     for i = 1:total_pts
%         for k = 1:size(U,1)
%             %  the likelihood of a data point in the distribution of a cluster (P_xi|wj)
%             pdf = mvnpdf(X(i,:),U(k,:),COV{k}); % the PDF of cluster k at sample 1
%             pdf_x_weighted(k) = pdf * P(k); % scale by the cluster weight
%         end
%         % responsability matrix (rows are data points, cols are clusters)
%         R(i,:) = pdf_x_weighted / sum(pdf_x_weighted);
%     end

    % ********************* M-step *********************
    
    soft_counts = sum(R); % total responsability for each cluster
    P = soft_counts / sum(soft_counts); % normalize for new cluster weights
    
    % update the centroids  
    for k = 1:K
        total = sum(R(:,k) .* X);
        U(k,:) = total / soft_counts(k);
    end
    
    %    ***** SLOW VERSION - DISCARDED *****
%     for k = 1:K
%         total = 0;
%         for i = 1:total_pts
%             total = total + R(i,k) * X(i,:);
%         end
%         U(k,:) = total / soft_counts(k);
%     end

	% update the covariances     
    for k = 1:K
            tmp = X - U(k,:);
            a = tmp.^2;
            b = tmp(:,1) .* tmp(:,2);
            tmp = R(:,k) .* [a(:,1) b b a(:,2)];
            total = sum(tmp);
            total = reshape(total,[2 2])';
        COV{k} = total / soft_counts(k);
    end
    
    %    ***** SLOW VERSION - DISCARDED *****
%     for k = 1:K
%         total = zeros(2,2);
%         for i = 1:total_pts
%             a = X(i,:) - U(k,:);
%             total = total + R(i,k) * (a' * a);
%         end
%         COV{k} = total / soft_counts(k);
%     end
    
    % (pseudo) log likelihood     
    log_likelihood = sum(log(sum(R,2)));
    
    % check stopping criteria     
    if abs(old_log_likelihood - log_likelihood) < 1e-16
        break;
    end
    
    old_log_likelihood = log_likelihood;
end

% initialize the labeled image with 0
labels = zeros(size(mask));

% put labels to corresponding pixel locations
labels(roi_idx) = label(R);

% figure,
% plot (X(:,1),X(:,2),'.g');
% hold on;
% plot(U(:,1),U(:,2),'.r');hold on;
% % xlim([0 12]);
% % ylim([0 12]);
% title("After");

end

