close, clear, clc;

a = 5*[randn(500,1)+5, randn(500,1)+5];
b = 5*[randn(500,1)+5, randn(500,1)-5];
c = 5*[randn(500,1)-5, randn(500,1)+5];
d = 5*[randn(500,1)-5, randn(500,1)-5];
e = 5*[randn(500,1), randn(500,1)];

data = [a;b;c;d;e];


plot(a(:,1),a(:,2),'.');
hold on;
plot(b(:,1),b(:,2),'r.');
plot(c(:,1),c(:,2),'g.');
plot(d(:,1),d(:,2),'k.');
plot(e(:,1),e(:,2),'c.');

[idx, ctrs] = kmeans(data,5);

for k = 1:2500
    text(data(k,1),data(k,2),num2str(idx(k)));
    hold on;
end
    
    c1 = data(idx == 1,:);
    
    cov(c1) 
    