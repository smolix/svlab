function [d] = train(d, x , y)

% d = train(d,x,y)
% Example code for training Lagrangian Support Vector Machines.
% 
% SV = TRAIN(SV,D,Y) returns a trained 
%                    Lagrangian Support Vector Object (alphas and beta) 
%                    D is a lagrangian support vector object,
%                    x is a data object or the patterns matrix
%                    Y is the labels matrix (only needed if the
%                    data is not in a data object)
%            
% Trains a lagrangian support vector machine (lsvm) 
% and returns the trained support
% vector object. This can be used by the predict function.
% Types of Support Vector Machines :
%
% File:        @lsvm/train.m
%
% Author:      Alexandros Karatzoglou
% Created:     02/08/2004
% Updated:     
%
% This code is released under the GNU Public License


lambdam = d.lambda;
itmax = d.itmax;
tol = d.tol;
nu = d.nu;
d.x = x;
kernel  = d.kernel;
[x, d.pivots]=chol_reduce(x,kernel,0.1,300,0.1);
x = x';
[n,m] = size(x) 
gamma = 1.9 * nu;
e = ones(1,m);
H = y'*[x; -e]';
it = 0;
S = H * inv((speye(n+1)*lambdam + H' * H));
alpha = (1 - S*(H'*e))/ lambdam ;
oldalpha = alpha + 1;
while it < itmax & norm(oldalpha - alpha) > tol
  z = (1 + pl(((speye(m)*lambdam*alpha')'+H*(H'*alpha))-gamma*alpha) - ...
       1);
  oldalpha = alpha;
  alpha = (z - S*(H'*z))/lambdam;
  it = it + 1;
end;

opt = norm(alpha - oldalpha); w = x*(y.*alpha'); b = - e * (y.* alpha');

d.w = zeros(m,1);
d.w(d.pivots) = w; 
d.b = b;

d.iter = it;
d.opt = opt;
d.gamma =gamma;


function pl = pl(x);
pl = (abs(x) +x)/2;

