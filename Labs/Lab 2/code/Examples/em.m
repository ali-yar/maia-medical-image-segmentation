close, clear, clc;

% a = mvnrnd([25 25],[20 0; 0 20],15);
% b = mvnrnd([125 125],[20 0; 0 20],10);
% c = mvnrnd([200 200],[20 0; 0 20],30);

a = mvnrnd([25 25],[30 0; 0 30],10);
b = mvnrnd([50 50],[30 0; 0 30],10);
c = mvnrnd([80 80],[30 0; 0 30],10);

X = [a;b;c];
U = [15 15; 60 60; 95 95] ; % centroids of clusters / means of the Gaussians
v = [15 0; 0 15]; % spread of the clusters / covariance of the Gaussians
COV = {v v v}; 
P = [1/3 1/3 1/3]; % weights / prior probabilities of clusters

figure,
plot (X(:,1),X(:,2),'.g');
hold on;
plot(U(:,1),U(:,2),'.r');
% xlim([0 12]);
% ylim([0 12]);
title("Initial");

% draw the samples (data points)
for k = 1:size(X,1)
    text(X(k,1),X(k,2),num2str(k-1));
    hold on;
end

% draw the clusters' centroids
for k = 1:size(U,1)
    text(U(k,1),U(k,2),char(64+k));
    hold on;
end

for count = 1:5

    % ********************* E-step *********************

    for i = 1:size(X,1)
        for k = 1:size(U,1)
            %  the likelihood of a data point in the distribution of a cluster (P_xi|wj)
            pdf = mvnpdf(X(i,:),U(k,:),COV{k}); % the PDF of cluster k at sample 1
            pdf_x_weighted(k) = pdf * P(k); % scale by the cluster weight
        end
        % responsability matrix (rows are data points, cols are clusters)
        R(i,:) = pdf_x_weighted / sum(pdf_x_weighted);
    end

    soft_counts = sum(R);

    % ********************* M-step *********************

    P = soft_counts / sum(soft_counts); % new cluster weights

    for k = 1:3
        total = 0;
        for i = 1:size(X,1)
            total = total + R(i,k) * X(i,:);
        end
        U(k,:) = total / soft_counts(k); % new means
    end

    COV = {};
    for k = 1:3
        total = zeros(2,2);
        for i = 1:size(X,1)
            a = X(i,:) - U(k,:);
            total = total + R(i,k) * (a' * a);
        end
        COV{k} = total / soft_counts(k);
    end

end

figure,
plot (X(:,1),X(:,2),'.g');
hold on;
plot(U(:,1),U(:,2),'.r');
% xlim([0 12]);
% ylim([0 12]);
title("After");

% draw the samples (data points)
for k = 1:size(X,1)
    text(X(k,1),X(k,2),num2str(k-1));
    hold on;
end

% draw the clusters' centroids
for k = 1:size(U,1)
    text(U(k,1),U(k,2),char(64+k));
    hold on;
end

% result
R
