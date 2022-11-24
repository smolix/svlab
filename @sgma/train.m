function [T,basisvecsindex,error_sequence,trace_K] = train(sgma_var,ker, X)
% function[T,basisvecsindex,error_sequence,trace_K] = train(sgma_var,ker, X)
%
% This code takes the set X of vectors from the input space
% and computes a subset which is a good basis for X.
%
% See also @sgma/sgma.m

% The algorithm for this is described in Section 11.2 of
% Learning with Kernels by Scholkopf and Smola, entitled 
% Sparse Greedy Matrix Approximation.
%
% In particular this code exploits the Cholesky decomposition 
% of K_nn, an iterative rank-1 update scheme, and the caching 
% of a subset of the relevant matrices, to achieve a reduced
% computational burden. These speed-ups are based on 
% the formulations detailed in Problems 11.5 and 11.6 of
% Scholkopf and Smola.
%
% The output T is the Cholesky decomposition of K_nn,
% i.e. TT'=K_nn, and basisvecsindex is a vector of numbers 
% which represent the elements of X chosen as the basis.
% error_sequence is a vector containing the sequence of values of
% the undermodelling error. trace_K is the obvious quantity.
%
% File:        @sgma/train.m
%
% Author:      Ben O'Loghlin
% Created:     25/09/00
% Updated:     31/10/00
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

% initialize variables

trace_ktilde = 0;
subsetsize = sgma_var.subsetsize;
maxiter = sgma_var.maxiter;
if sgma_var.blocksize ==0
	blocksize = ker.blocksize;
else
	blocksize = sgma_var.blocksize;
end
m=size(X,2);
numvecsleft =m;
whichvecsleft=linspace(1,m,m);

% sgma_var.errorbound is expressed as a fraction of unity:
% multiply by trace(K) to scale it 
%		for comparison with trace(Ktilde)

trace_K = 0;
for i=1:m
	trace_K = trace_K + sv_dot(ker,X(:,i));
end
approx_error = trace_K;
error_bound = trace_K * sgma_var.errorbound;
error_sequence=trace_K;
numbasisvecs=0;
whichbasisvecs=zeros(1,m);

% T_inv_K_mn is the matrix inv(T)*K_mn'
T_inv_K_mn = zeros(0,m);

if (sgma_var.verbose >0 )		% initial report
  report = sprintf('\nInitiating main loop, trace_K = %g\n',trace_K);
  disp(report);
end	

% main loop
while ((approx_error > error_bound)... 
		& (numvecsleft > 0) & (numbasisvecs < maxiter))
	
	% allocate another chunk of memory
	if mod(numbasisvecs,blocksize) ==0
		T_inv_K_mn = [T_inv_K_mn;zeros(blocksize,m)];
	end
	
  	if numvecsleft<subsetsize
	  	subsetsize=numvecsleft;
	end

	% generate a vector which contains the indices (in terms of 
	% the ordering of X) of a random set of vectors in 
	% (X - already selected basis vectors), of size subsetsize

	randomindex=choosesubset(subsetsize,numvecsleft);
	randomindex=randomindex(1:subsetsize);
	randomvecsindex=whichvecsleft(randomindex);
	
	% make a vector "error_cand" containing the Err(alpha) for 
	% each vector.

	k_bar_cand = sv_dot(ker,X,X(:,randomvecsindex));
	kappa_cand=zeros(1,subsetsize);

	for i=1:subsetsize
		kappa_cand(i) = k_bar_cand(randomvecsindex(i),i);	
	end
	
	if numbasisvecs==0
		delta_cand=dot(k_bar_cand,k_bar_cand)./kappa_cand;
		tau_sq_cand = kappa_cand;
	else		
		k_cand=k_bar_cand(whichbasisvecs(1:numbasisvecs),:);
		t_cand=T\k_cand;
		tau_sq_cand = kappa_cand - dot(t_cand,t_cand,1);
		for i=1:subsetsize
			%pretty ugly way to overcome numerical problems
			if tau_sq_cand(i)<=0
				tau_sq_cand(i)=0.0000000001;
			end
		end
		dist_cand = k_bar_cand - T_inv_K_mn(1:numbasisvecs,:)'*t_cand;
		delta_cand = dot(dist_cand,dist_cand)./tau_sq_cand;
	end
	
	% choose basis vector with the highest error difference
	[best_delta,bvi] = max(delta_cand);
		% bvi stands for best vector index
		
	% update the T matrix and T_inv_K_mn
	
	if numbasisvecs==0
		T = sqrt(tau_sq_cand(bvi));
		T_inv_K_mn(1,:) = k_bar_cand(:,bvi)'/sqrt(tau_sq_cand(bvi));
		delta_sequence=zeros(1,0);	
	else 
		T = [T,zeros(numbasisvecs,1);...
			 t_cand(:,bvi)',sqrt(tau_sq_cand(bvi))];
		T_inv_K_mn(numbasisvecs+1,:) = ...
			(k_bar_cand(:,bvi)' ...
			- t_cand(:,bvi)'*T_inv_K_mn(1:numbasisvecs,:)) ...
			/ sqrt(tau_sq_cand(bvi));
	end

	trace_ktilde = trace_ktilde + best_delta;
	approx_error = approx_error - best_delta;
	
	error_sequence=[error_sequence,approx_error];
	delta_sequence=[delta_sequence,best_delta];
	
	% Take basis vector out of whichvecsleft and 
	%   		put it into whichbasisvecs
	whichvecsleft(randomvecsindex(bvi)) = whichvecsleft(numvecsleft);
	numvecsleft = numvecsleft - 1;
	numbasisvecs = numbasisvecs + 1;
	whichbasisvecs(numbasisvecs) = randomvecsindex(bvi);
  if (sgma_var.verbose > 1)
    if (mod(numbasisvecs,50)==1)
      report = ...
	  sprintf(['n \twhich_X delta \tdelta/trace_K \tresidual error' ...
	    '\n--------------------------------------------------']);
      disp(report);
    end
    report = sprintf('%i \t%i   \t%g \t%g  \t%g', ...
		     numbasisvecs, randomvecsindex(bvi), ...
		     best_delta, best_delta/trace_K, approx_error/trace_K);    
    disp(report);
  end	
end

basisvecsindex=whichbasisvecs(1:numbasisvecs);

if (sgma_var.verbose >0 )			% final report
  if (approx_error < error_bound)
    disp(['Algorithm terminated successfully: lower bound on residual error' ...
	  ' was reached\n']);
  elseif (numbasisvecs>=maxiter)
    disp('Algorithm terminated successfully: maximum iterations carried out\n');
  elseif (numvecsleft==0)
    disp('Algorithm terminated successfully: all input vectors used up\n');
  else
    disp('Algorithm terminated for unknown reason - investigate this error\n');
  end
  if (sgma_var.verbose ==1)
    report = sprintf(['Number of iterations: %i \nFractional approximation' ...
      ' error:%g\n'], numbasisvecs, approx_error/trace_K);    
    disp(report);
  end
end	








