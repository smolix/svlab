
% example using online_pr
% create toy data
x=[randn(11,200),randn(11,200)+2]
y=[ones(200,1);-ones(200,1)]

% initialize Gaussian kernel 
k=rbf_dot
k.sigma = 0.1
% initialize online_pr object 
on=online_pr
%create random indexes
ind = floor(400*rand(400,1))';

% iterate through data 
for i = ind 
[phi,on]=train(on,k,x(:,i),y(i,:),0.001,0.1)
end

% use predict on the data set
predict(on,k,x)
