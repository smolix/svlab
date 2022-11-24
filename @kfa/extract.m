function [features] = extract(kfa, x)
				%[test_features] = extract(kfa, x)
%
% See Also: @kfa/kfa.m, @kfa/train.m

%Extract computes the features of the test points with respect to
%the eigenvectors of the covariance matrix of training points x
%under the given kernel, with the appropriate centering in 
%feature space. The offset vector is calculated by the "train"
%function, and is used to make the calculations a bit faster.
%
% for additional information see Advances in Kernel Methods
%    by Scholkopf et. al., equations 20.30 - 20.34.
%
% File:        @kfa/extract.m
%
% Author:      Alexandros Karatzoglou
% Created:     18/09/04
% Updated:     18/09/04
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

% set size of covariance matrix based on number of training points
% and number of test points





if (nargin ~= 2)
  error('wrong number of arguments');
else


  if isa(x ,'data')
    x =  x.train.patterns;
  end;

   if ~isa(kfa, 'kfa')
     disp('This is no kfa object');
     return;
   end;



    features =  sv_mult(kfa.kernel,x,kfa.x,kfa.alpha)';
end
