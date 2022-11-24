function [z, l, index, residual_trace] = red_chol(d, kernel, data, n);
% RED_CHOL Reduced Cholesky decomposition via positive diagonal pivoting
%
%        [z, l, index, residual_trace] = red_chol(kernel, data, n);
%
% d      : class (not really needed for this routine yet)
% kernel : kernel object (we don't want to pass K)
% data   : upon which to construct the dot product matrix
% n      : number of dimensions to be extracted
% 
% z      : decomposes K into z z'
% l      : lower triangular matrix of the nxn submatrix
% index  : data chosen
% residual_trace : remaining trace between K and its approximation

% File:        red_chol.m
%
% Author:      Alex J. Smola
% Created:     11/05/01
% Updated:     
%
% This code is released under the GNU Public License
% Copyright by Telstra Research and The Australian National University

[d, m] = size(data); 			% we get the dimensionality of the data

diag_k = zeros(m,1); 			% initial trace
for i=1:m
  diag_k(i) = sv_dot(kernel, data(:,i));
end
residual_k = diag_k;			% residual trace

% setting up data space
z = zeros(m,n);                         % this will be for the decomposition
index = zeros(n, 1);  			% index vector of chosen
                                        % patterns
l = zeros(n,n);				% tridiagonal matrix
subdata = zeros(d, n);			% temporary data storage
					
% pivoting cholesky - sloooow with matlab
for i=1:n				% loop over extraction
                                        % steps
    [dummy, idx] = max(residual_k);	% find element to pivot for
    index(i) = idx;			% write to index 
    subdata(:,i) = data(:,idx);		% and story pattern
    
    % compute lower triangular matrix
    if (i == 1)
      l(i,i) = sqrt(sv_dot(kernel, subdata(:,i))); 
      z(:,i) = (1/l(i,i)) * sv_dot(kernel, data, subdata(:,i));
    else
      ltemp = l(1:(i-1),1:(i-1)) \ ...
	      sv_dot(kernel, subdata(:,1:(i-1)), subdata(:,i)); 
      l(i,i) = sqrt(sv_dot(kernel, subdata(:,i)) - sum(ltemp.^2));
      l(i, 1:(i-1)) = ltemp';
      
      % update z
      z(:,i) = (1/l(i,i)) * (sv_dot(kernel, data, subdata(:,i)) - ...
			     z(:,1:(i-1)) * ltemp);
      
      % and the trace
    end;
    residual_k = residual_k - (z(:,i).^2);
end;
residual_trace = sum(residual_k);

