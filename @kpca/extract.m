function [test_features] = extract(kpca_var, ker, X, T, offset, ...
				   e_vecs, e_vals)
%[test_features] = EXTRACT(kpca_var, kernel, training_points,
%test_points, offset, eigenvectors, eigenvalues)
%
% See Also: @kpca/kpca.m, @kpca/train.m

%Extract computes the features of the test points with respect to
%the eigenvectors of the covariance matrix of training points x
%under the given kernel, with the appropriate centering in 
%feature space. The offset vector is calculated by the "train"
%function, and is used to make the calculations a bit faster.
%
% for additional information see Advances in Kernel Methods
%    by Scholkopf et. al., equations 20.30 - 20.34.
%
% File:        @kpca/extract.m
%
% Author:      Ben O'Loghlin
% Created:     18/09/00
% Updated:     18/09/00
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

% set size of covariance matrix based on number of training points
% and number of test points

train_size = size(X,2);
test_size = size(T,2);
numfeatures = kpca_var.numfeatures;
if (numfeatures==0)
  numfeatures=train_size;
end


% centering in feature space
% the rest of this program basically just computes 
% Eq 20.34 using some matrix factorization tricks to make it a 
% bit faster.

unit=ones(train_size)/train_size;
K_offset=zeros(test_size,train_size);

for (i=1:test_size)
  K_offset(i,:)=offset';
end

%normalize the eigenvector by the square root of the eigenvalues
    for i=1:size(e_vecs,2)
        e_vecs(:,i) = e_vecs(:,i)/sqrt(e_vals(i));
    end	

% alpha_norm is the row vector whose entries are the weight 
% of each eigenvector

alpha_norm = zeros(1,numfeatures);
for (i=1:train_size)
  for (j=1:numfeatures)
    alpha_norm(j)= alpha_norm(j) + e_vecs(i,j);
  end
end

alpha_norm_matrix = zeros(train_size,numfeatures);
for (i=1:train_size)
  alpha_norm_matrix(i,:) = alpha_norm;
end

test_features = sv_mult(ker,T,X,e_vecs(:,1:numfeatures)-alpha_norm_matrix);

for (j=1:numfeatures)
  alpha_offset = offset'*e_vecs(:,j);
  for (i=1:test_size)
    test_features(i,j) = test_features(i,j) + alpha_offset;
  end
end



