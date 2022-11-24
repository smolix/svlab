function [phi, d] = train(d, kernel, x, y, lambda, nu)
%TRAIN Show a pattern to the online machine
%
%	PHI = TRAIN(D, KERNEL, X, LAMBDA, NU) shows the pattern X to the
%	online machine using the kernel KERNEL and parameters LAMBDA and
%	NU (where D is an online_re object) and returns PHI
%	and a D trained with the pattern X. D can then be re-used
%	on the next pattern.
%
%	kappa (i.e. SVLAB_ONLINE_KAPPA) is not used and not updated at
%	present, so use with a poly_dot kernel may yield weird results.

% File:        @online_re/train.m
%
% Author:      Alexandros Karatzoglou
% Created:     16/06/04
% Updated:     16/06/04
%
% This code is released under the GNU Public License
% Copyright by The Australian National University


%%d.online_kappa


if (nargin ~= 6)
  error('wrong number of arguments');
else

if(~d.dim)
  d.dim = size(x,1)
  %% check if data has correct dimension
  if(d.dim ~= size(d.online_data,1))
    d.online_data = zeros(d.dim,d.bufsize);
  end
end

  % 1.  If the buffer is not full, we must sv_mult on a subset.
  % 2.  Once the buffer has been filled, it will stay filled.
  % 3.  Buffer element ordering doesn't matter for sv_mult.



  buffer_is_not_full = ((d.online_start == 1) & ...
			(d.online_stop < d.bufsize));
  
  if (buffer_is_not_full)
 
    phi = sv_mult(kernel, x, d.online_data(:,1:d.online_stop), ...
		d.online_alpha(1:d.online_stop));
  else
    phi = sv_mult(kernel, x, d.online_data, d.online_alpha); 
  end
    
  d.online_alpha = (1-lambda) * d.online_alpha;

    if (abs(y - phi) < d.online_sigma)
      if (buffer_is_not_full)
	d.online_stop = d.online_stop + 1;
      else
	d.online_stop = mod(d.online_stop,d.bufsize) + 1;
	d.online_start = mod(d.online_start,d.bufsize) + 1;
      end
      d.online_alpha(d.online_stop) = sign(y-phi)*lambda;
      d.online_sigma = d.online_sigma + (1 - nu)*lambda
      d.online_data(:,d.online_stop) = x;
   
    else
      d.online_alpha(d.online_stop) = (y-phi)/d.online_sigma;
      d.online_sigma = d.online_sigma - lambda*nu;
    end
   
    
end
