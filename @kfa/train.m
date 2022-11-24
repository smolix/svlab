function [d] = train(kfa, x)
% function[] = train(kfa, k, x)
%
% This code takes the set x of vectors from the input space
% and does projection pursuit to find a good basis for X.
%
% See also @kfa/kfa.m

% The algorithm for this is described in Section ??.? of
% Learning with Kernels by Scholkopf and Smola, entitled 
% Kernel Feature Analysis.
%
% File:        @kfa/train.m
%
% Author:      Alexandros Karatzoglou
% Created:     02/08/04
% Updated:     02/08/04
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

% initialize variables

k = kfa.kernel;
subset = kfa.subsetsize;
normalize = kfa.normalized;
numbasisvecs=0;
m=size(x,2);
features = kfa.features;

if (features==0)
  features = subset;
end

alpha_zero = ones(subset,1);	       
alpha = zeros(subset, features);	
alpha_feat = zeros(features);		
idx = [];

Q = zeros(subset,1);		

Q_feat = zeros(features,1);	
ind = floor(m*rand(subset,1));

K = sv_dot(k,x(:,ind),x);

for i=1:features
  if (i > 1)
    projections = K .* (alpha_zero * ones(1,m)) + ...
	alpha(:,1:(i-1)) * K(idx,:);
  else
    projections = K .* (alpha_zero * ones(1,m));
  end    
 
  for j=1:subset
    Q(j) = std(projections(j,:));	% does centering automatically
  end;
  Q(idx) = zeros(1,i-1);		% blank out used directions

  [max_q, max_idx] = max(Q);
				% store the entries
  if (i > 1)
    alpha_feat(i,1:(i-1)) = alpha(max_idx,1:(i-1));
  end;
  alpha_feat(i,i) = alpha_zero(max_idx);
  idx(i) = max_idx;			% that's the new index we're
                                        % looking for
  Q_feat(i) = max_q;					
  			
	
  K_sub = K(idx, idx);			% a submatrix we'll need quite often
  alpha_sub = alpha_feat(i,1:i);		% the new feature vector;
  phisquare = alpha_sub * K_sub * alpha_sub';
  dotprod = alpha_zero .* (K(:,idx) * alpha_sub') + ...
      alpha(:,1:i) * (K_sub * alpha_sub');
  dotprod = dotprod / phisquare;	% the update factors
  alpha(:,1:i) = alpha(:,1:i) - dotprod * alpha_sub;

  
  if (normalize == 1)

    sumalpha = alpha_zero + sum(abs(alpha)')';
    alpha_zero = alpha_zero ./ sumalpha;
    alpha = alpha ./ (sumalpha * ones(1,features));
  end;

end;  


kfa.alpha = alpha_feat;
kfa.indx = idx;
kfa.x = x(:,idx);

d = kfa;












