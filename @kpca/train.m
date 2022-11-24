function [e_values, e_vectors, offset] = train(kpca_var,ker, X)
%[e_values, e_vectors, offset] = TRAIN(kpca_var, kernel, training_patterns)
%
% See also: @kpca/kpca.m, @kpca/extract.m

%
%Train computes the eigensystem of K_n, the normalized 
%gram matrix induced by the kernel on the training set. 
%Note that the eigenvectors are not normalized, for reasons of 
%numerical stability in the case where some eigenvalues are close
%to zero.
%This function also returns an M*1 matrix called 'offset' which
%represents the offset of the eigenvectors in K-space due to
%centering of the training data. In the terminology of eq 20.34 in 
%Advances in Kernel Methods, Scholkopf et al,
%   offset = RK - RK1m, where R is the row vector ones(1,M) and 
%                       1m is the matrix ones(M)/M.
%
% File:        @kpca/train.m
%
% Author:      Ben O'Loghlin
% Created:     10/09/00
% Updated:     18/09/00
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

% generate normalized K matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set size of covariance matrix based on number of input points
cov_size = size(X,2);

% create the covariance matrix

K = sv_dot(ker, X);

% centering in feature space, basically implements Scholkopf
% et. al.'s Eq 20.32 but using some matrix factorizations to 
% make it a bit faster.

unit_vec = ones(cov_size,1);

K_= mean(K);
K_sum = mean(*K_);

K_n = K - unit_vec*K_' - K_*unit_vec' + K_sum;

% compute eigensystem
if (kpca_var.numfeatures == 0)
	[e_vectors, e_values]= eig(K_n/cov_size);
    e_values = real(diag(e_values));
else
	[e_vectors, e_values]= eigs(K_n/cov_size,kpca_var.numfeatures);
    e_values = real(diag(e_values));
end

offset = K * e_vectors;










