function R = getEMProbs(X,mask,K)
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
%   R: Mx3 cluster responsabilities matrix
% 

% max number of iterations of the E-M steps
max_iters = 20;

% keep only non-zero pixels
X = X(mask == 1);

total_pts = size(X,1);

% k-means to get initial centroids
% [tmp, centers] = kmeans(X,K);
% c{1} = X(tmp == 1);
% c{2} = X(tmp == 2);
% c{3} = X(tmp == 3);
% [~, order] = sort(centers);
% U = [centers(order(1))  centers(order(3))  centers(order(2))];
% VAR = [var(c{order(1)}) var(c{order(3)}) var(c{order(2)})];
% P = [1/3 1/3 1/3];

% This was infered from the atlas template. It also helps in obtaining
% correct labelling.
U = [470    1367    885];
VAR = [52482    35189    33638];
P = [1/3 1/3 1/3];

old_log_likelihood = 0;

for count = 1:max_iters
   
    % ********************* E-step *********************

    % init
    pdf_x_weighted = zeros(total_pts,K); % weighted likelihood
    R = zeros(total_pts,K); % responsability matrix
    
    % the likelihood of each sample in the distribution of a cluster (P_xi|wj)
    for k = 1:K
        pdf = normpdf(X,U(k),sqrt(VAR(k))); % the PDF of cluster k at each sample
        pdf_x_weighted(:,k) = pdf * P(k); % scale by the cluster weight
    end
    % responsability matrix (rows are data points, cols are clusters)
    for k = 1:K
        R(:,k) = pdf_x_weighted(:,k) ./ sum(pdf_x_weighted,2);
    end
    
    % ********************* M-step *********************
    
    soft_counts = sum(R); % total responsability for each cluster
    P = soft_counts / sum(soft_counts); % new cluster weights (by normalizing)
    
    % update the centroids  
    for k = 1:K
        total = sum( R(:,k) .* X );
        U(k) = total / soft_counts(k);
    end

	% update the variances     
    for k = 1:K

        total = sum( R(:,k) .* (X - U(k)) .^2 );
        VAR(k) = total / soft_counts(k);
    end
    
    % (pseudo) log likelihood     
    log_likelihood = sum(log(sum(R,2)));
    
    % check stopping criteria     
    if count > 1 && abs(old_log_likelihood - log_likelihood) < 1e-14
        break;
    end
    
    old_log_likelihood = log_likelihood;
end

end

