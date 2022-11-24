function td = tune(sv,d,y)
% Tune function for support vector machines 
%  
%  TD = TUNE(SV,D,Y)   returns a trained Support Vector Object with
%                      the optimal set of parameters 
%
%                   SV is a support vector oject
%                    D is a data object or the patterns matrix
%                    Y is the labels matrix (only needed if the
%                       data is not in a data object) 
% Tune calculates the range of optimal sigmas (kernel parameters)
% and performes a grid search on the given range of the Support
% Vector parameter C. It returns a trained support vector object
% on the optimal set of parameters.
% 10-fold crossvalidation is used for validating a set of parameters.
%
% File:        @svm/tune.m
%
% Author:      Alexandros Karatzoglou
% Created:     11/12/02
% Updated:     11/12/02
% 



if (nargin < 2) | (nargin > 5)
  error('wrong number of arguments');
else
  
  if isa(d,'data')
    x =  d.train.patterns; 
    y =  d.train.labels;
    m =  size(x,2);
  else 
    x = d;
    m = size(x,2);
  end;
  
  
  RANDSAMPLES  = ceil(m);
  BLOCKSIZE = 10;                        % block for processing
  STEPS  = floor(RANDSAMPLES/BLOCKSIZE) ;
  sv_train = svm;
  nfold=5;
  an=6;
  cr_err2 = 1;
  permute = randperm(m); % we permute the training data
  
  if length(sv.kernel.sigma) == 1
    
    randindex = ceil(m * rand(2,ceil(RANDSAMPLES * 1.1)));
    temp = randindex(1,:) ~= randindex(2,:);
    randindex = randindex(:,temp);
    dists = zeros(RANDSAMPLES,1);
    
    for i=1:STEPS  % try to find the obtimal range of sigmas for the kernel
      range = (((i-1) * BLOCKSIZE)+1):(i*BLOCKSIZE);
      temp = x(:,randindex(1,range)) - x(:,randindex(2,range));
      dists(range) = dot(temp, temp);
    end;
    dists = sort(dists(dists~=0));
    sl = dists(ceil(0.1 * length(dists)));
    su = dists(ceil(0.9 * length(dists)));
    sv.kernel.sigma = 1./(exp((1/an)*log(su/sl)*[0:an])*sl);
  end
  
  if  equal(sv.kernel.name,'poly_dot') kernel_param = sv.kernel.degree;
  else kernel_param = sv.kernel.sigma;
  end;
  
  for i = 1:length(sv.c)
    sv_train.c = sv.c(i);
    cr_err1 = 1;
    for j =  1:length(kernel_param)
      if  equal(sv.kernel.name,'poly_dot') 
	sv_train.kernel.degree =  sv_train.kernel.degree(j);
      else  sv_train.kernel.sigma = sv.kernel.sigma(j);
      end
      cr_err = 0 ;
      for v = 1:nfold
	
	x_train = [x(:,permute(1:ceil((v-1)*m/nfold))),x(:,permute(ceil(v*m/nfold):m))];
	y_train = [y(:,permute(1:ceil((v-1)*m/nfold))),y(:,permute(ceil(v*m/nfold):m))];
	x_valid = x(:,permute(ceil((v-1)*m/nfold+1):ceil(v*m/nfold)));
	y_valid = y(:,permute(ceil((v-1)*m/nfold+1):ceil(v*m/nfold)));
	sv_valid = train(sv_train,x_train,y_train);
	
	switch lower(sv.type)
	  
	 case{'c-svc','nu-svr' }
	  
	  y_est = sv_mult(sv_valid.kernel,x_valid,x_train,sv_valid.alpha.*sv_valid.y') ...
		  + sv_valid.beta;
	 
	  err = (sum(y_valid' .* y_est < 0) / RANDSAMPLES );
	  loss =  sum(max(1 - y_valid' .* y_est, 0))/RANDSAMPLES;
	  
	 case{'epsilon-svr','nu-svr'}
	  
	  y_est = (sv_mult(sv_valid.kernel, x_valid, - sv_valid.alpha(1:size(sv_valid.x,2))+sv.alpha(size(sv_valid.x,2)+1:2*size(sv_valid.x,2))) + sv_valid.beta)';
	  err = sqrt(sum((y_valid - y_est).^2)/RANDSAMPLES);
	  l1_err = sum(abs(y_valid - y_est))/RANDSAMPLES;
	  loss = sum(max(abs(y_valid - y_est) - sv_valid.epsilon, 0))/RANDSAMPLES;
	  
	 otherwise	      
	  disp('Unknown SVM type, supported types are : c-svc nu-scv, eps-svr, nu-svr');
	  
	end;
	cr_err = cr_err + err;      
      end;
       if  equal(sv.kernel.name,'poly_dot')
	 disp(['degree ' , num2str(sv_valid.kernel.degree), ' c parameter: ', num2str(sv_valid.c), ...
	       ' validation error: ', num2str(cr_err) ]);
       else
	 disp(['1/2sigma^2: ' , num2str(sv_valid.kernel.sigma), ' c parameter: ', num2str(sv_valid.c), ...
	       ' validation error: ', num2str(cr_err) ]); 
      end
      if (cr_err < cr_err1)
	cr_err1 = cr_err;
	sv_good = sv_valid;
      end;
    end;
    
    if (cr_err1 < cr_err2)
      cr_err2 = cr_err1;
      sv_best = sv_good ;
      if  equal(sv.type,'nu-svc') | equal(sv.type,'nu-svr')
	sv.nu = cr_err2;
      end;
    end;
  end;
end;
if  equal(sv.kernel.name,'poly_dot')
  disp([' degree ' , num2str(sv_valid.kernel.degree), ' c parameter: ', num2str(sv_valid.c), ...
	'validation error: ', num2str(cr_err) ]);
else
  disp(['1/2sigma^2: ' , num2str(sv_valid.kernel.sigma), ' c parameter: ', num2str(sv_valid.c), ...
	' validation error: ', num2str(cr_err) ]); 
end

sv_final = train(sv_best,x,y);
td = sv_final;

