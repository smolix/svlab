function [primal, dual, how] = optimize(optimizer, c, H, A, b, r, ...
					l, u, Hnn)
%[PRIMAL, DUAL, HOW] = OPTIMIZE(optimizer, c, H, A, b, r, l, u)
%
%optimize solves the quadratic programming problem
%
%minimize   c' * primal + 1/2 primal' * H * primal
%subject to b <= A*primal <= b + r
%           l <= x <= u
%           d is the optimizer itself
%
%returns primal and dual variables (i.e. x and the Lagrange
%multipliers for b <= A * primal <= b + r
%
%for additional documentation see 
%     R. Vanderbei 
%     LOQO: an Interior Point Code for Quadratic Programming, 1992

% File:        @intpoint/optimize.m
%
% Author:      Alex J. Smola, Alexandros Karatzoglou
% Created:     12/12/97
% Updated:     08/05/00
%
% This code is released under the GNU Public License
% Copyright by GMD FIRST and The Australian National University

if(nargin < 8 | nargin >9) 
     error('wrong number of arguments')
elseif nargin == 8
  if (size(H,1) == size(H,2))
    smw = 0;
    hnn = 0;
  elseif (size(H,1) < size(H,2))
    smw = 1;
    hnn = 0; 
  end
elseif nargin == 9 
  smw = 1;
  hnn = 1;
end


% gather some starting data
[m, n] = size(A); 

if(size(H,1) ~= size(H,2) & size(H,1)> size(H,2))
  error('H matrix has to be symmetric or second dimension bigger than first')
	   
  
elseif(size(b,1) ~=1 & size(b,1)~=m)
  error('rows of b not compatible with A')
  
elseif(size(b,2)~=1)
  error('b has to be a column vector')
  
elseif(size(l,1)~= n)
 error('rows of l dont match problem')
                                   
 elseif(size(u,1)~= n)
 error('rows of u dont match problem')
		   
elseif(size(l,2)~=1)
  error('l has to be a column vector')
  
elseif(size(u,2)~=1)
  error('u has to be a column vector')
  
elseif(size(c,1)~=n)
   error('number of rows in c dont match problem')
 
elseif(size(u,1)~= n)
  error('rows of u dont match problem')
  
elseif(size(l,2)~=1)
  error('l has to be a column vector')
   
elseif(size(u,2)~=1)
  error('u has to be a column vector')
    
elseif(size(c,1)~=n)
  error('number of rows in c dont match problem')

				   
elseif(size(c,2)~=1)
  error('c has to be a column vector')
  
elseif(size(r,1)~=1 & size(r,1)~=m)
  error('rows of r not combatible with b')
  
elseif(size(r,2)~=1)
  error('r has to be a column vector')
end

H_diag = diag(H);
H_x    = H;				% faster with temp variables

b_plus_1 = norm(b) + 1;
c_plus_1 = norm(c) + 1;
one_x = -ones(n,1);
one_y = -ones(m,1);

% starting point
if(smw == 0)
  for i = 1:n 
    H_x(i,i) = H_diag(i) + 1; 
  end;
elseif (smw == 1)
  smw_n = size(H, 1);
end;
H_y = eye(m);
c_x = c;
c_y = b;

if (smw == 0) 
  % and solve the system [-H_x A'; A H_y] [x, y] = [c_x; c_y]
  R = chol(H_x);
  a_r = A / R;
  c_r = c_x'/ R;
  H_tmp = a_r * a_r' + H_y;
  y = H_tmp \ (c_y + a_r * c_r');
  x = R \ (a_r' * y - c_r');
elseif (smw == 1)
  % this time it should be really clean (Alex)
  if(hnn == 0)
    V = eye(smw_n);
  elseif (hnn == 1)
    V = Hnn;
  end;
  smw_inner = chol(V + H * H'); % inner term in the
					 % SMW formula
  smw_a1 = A';			% takes care of diagonal 
  smw_c1 = c_x;			% no scaling (D = 1)
  smw_a2 = smw_a1 - (H' * (smw_inner \ (smw_inner' \ (H * smw_a1))));
  smw_c2 = smw_c1 - (H' * (smw_inner \ (smw_inner' \ (H * smw_c1))));
			 
  y = (A * smw_a2 + H_y) \ (c_y + A * smw_c2);
  x = smw_a2 * y - smw_c2;
end;



g = max(abs(x - l), optimizer.bound);
z = max(abs(x), optimizer.bound);
t = max(abs(u - x), optimizer.bound);
s = max(abs(x), optimizer.bound);
v = max(abs(y), optimizer.bound);
w = max(abs(y), optimizer.bound);
p = max(abs(r - w), optimizer.bound);
q = max(abs(y), optimizer.bound);

mu = (z' * g + v' * w + s' * t + p' * q)/(2 * (m + n));

sigfig = 0;

counter = 0;

alfa = 1;

if (optimizer.verbose > 0)	% print at least one status report
  report = sprintf(['Iter \tPrimalInf \tDualInf \tSigFigs ' ...
		    '\tRescale \tPrimalObj \tDualObj']); 
  disp(report);
end

while (counter < optimizer.maxiter),
  %update the iteration counter
  counter = counter + 1;
  
  %central path (predictor)
  if (smw == 0)
    H_dot_x = H * x;
  elseif (smw == 1)
    if(hnn == 0)
      H_dot_x = (H' * (H * x));
    elseif(hnn == 1)
       H_dot_x = (H' * (inv(Hnn) * (H * x)));
    end;
  end;
  rho = b - A * x + w;
  nu = l - x + g;
  tau = u - x - t;
  alpha = r - w - p;
  
  sigma = c - A' * y - z + s + H_dot_x;
  beta = y + q - v;
  
  gamma_z = - z;
  gamma_w = - w;
  gamma_s = - s;
  gamma_q = - q;
  
  % instrumentation
  x_dot_H_dot_x = x' * H_dot_x;
  
  primal_infeasibility = norm([rho; tau; alpha; nu]) / b_plus_1;
  dual_infeasibility = norm([sigma; beta]) / c_plus_1;
  
  primal_obj = c' * x + 0.5 * x_dot_H_dot_x;
  dual_obj = b' * y - 0.5 * x_dot_H_dot_x + l' * z - u' * s - r' * q;
  
  old_sigfig = sigfig;
  sigfig = max(-log10(abs(primal_obj - dual_obj)/(abs(primal_obj) + 1)), 0);
  
  if (sigfig >= optimizer.sigfig) break; end;
  if (optimizer.verbose > 1)			% final report
    report = sprintf('%i \t%e \t%e \t%e \t%e \t%e \t%e', ...
		     counter, primal_infeasibility, dual_infeasibility, ...
		     sigfig, alfa, primal_obj, dual_obj);    
    disp(report);
  end
  
  % some more intermediate variables (the hat section)
  hat_beta = beta - v .* gamma_w ./ w;
  hat_alpha = alpha - p .* gamma_q ./ q;
  hat_nu = nu + g .* gamma_z ./ z;
  hat_tau = tau - t .* gamma_s ./ s;
  
  % the diagonal terms
  d = z ./ g + s ./ t;
  e = 1 ./ (v ./ w + q ./ p);
  
  % initialization before the big cholesky
  if (smw == 0)
    for i = 1:n H_x(i,i) = H_diag(i) + d(i); end;
  end;
  H_y = diag(e);
  c_x = sigma - z .* hat_nu ./ g - s .* hat_tau ./ t;
  c_y = rho - e .* (hat_beta - q .* hat_alpha ./ p);
  
  if (smw == 0)
    % and solve the system [-H_x A'; A H_y] [delta_x, delta_y] = [c_x; c_y]
    R = chol(H_x);
    a_r = A / R;
    c_r = c_x'/ R;
    H_tmp = a_r * a_r' + H_y;
    delta_y = H_tmp \ (c_y + a_r * c_r');
    delta_x = R \ (a_r' * delta_y - c_r');
  elseif (smw == 1)
     % this time it should be really clean (Alex)
     if (hnn == 0)
       V = eye(smw_n);
     elseif (hnn == 1)
       V = Hnn;
     end;
     smw_inner = chol(V + chunkmult(H, 2000, d));
     %  smw_innerold = chol(V + chunkmultold(H, 2000, d));
     smw_a1 = A';			
     % and scale it
     for i=1:m
       smw_a1(:,i) = smw_a1(:,i) ./ d;
     end;
     smw_c1 = c_x ./ d;			
     smw_a2 = A' - (H' * (smw_inner \ (smw_inner' \ (H * smw_a1))));
     % and scale it
     for i=1:m
       smw_a2(:,i) = smw_a2(:,i) ./ d;
     end;
     smw_c2 = (c_x - (H' * (smw_inner \ (smw_inner' \ (H * smw_c1)))))./d;
     
     delta_y = (A * smw_a2 + H_y) \ (c_y + A * smw_c2);
     delta_x = smw_a2 * delta_y - smw_c2;
  end;
  %backsubstitution
  delta_w = - e .* (hat_beta - q .* hat_alpha ./ p + delta_y);
  
  delta_s = s .* (delta_x - hat_tau) ./ t;
  delta_z = z .* (hat_nu - delta_x) ./ g;
  delta_q = q .* (delta_w - hat_alpha) ./ p;
  
  delta_v = v .* (gamma_w - delta_w) ./ w;
  delta_p = p .* (gamma_q - delta_q) ./ q;
  delta_g = g .* (gamma_z - delta_z) ./ z;
  delta_t = t .* (gamma_s - delta_s) ./ s;
  
  %compute update step now (sebastian's trick)
  alfa = - (1 - optimizer.margin) / min([delta_g ./ g; delta_w ./ w; delta_t ./ t;
                    delta_p ./ p; delta_z ./ z; delta_v ./ v;
		    delta_s ./ s; delta_q ./ q; -1]);
  
  newmu = (z' * g + v' * w + s' * t + p' * q)/(2 * (m + n));
  newmu = mu * ((alfa - 1) / (alfa + 10))^2;

  %central path (corrector)
  gamma_z = mu ./ g - z - delta_z .* delta_g ./ g;
  gamma_w = mu ./ v - w - delta_w .* delta_v ./ v;
  gamma_s = mu ./ t - s - delta_s .* delta_t ./ t;
  gamma_q = mu ./ p - q - delta_q .* delta_p ./ p;
  
  % some more intermediate variables (the hat section)
  hat_beta = beta - v .* gamma_w ./ w;
  hat_alpha = alpha - p .* gamma_q ./ q;
  hat_nu = nu + g .* gamma_z ./ z;
  hat_tau = tau - t .* gamma_s ./ s;
  
  % the diagonal terms
  %d = z ./ g + s ./ t;
  %e = 1 ./ (v ./ w + q ./ p);
  
  % initialization before the big cholesky
  %for i = 1:n H_x(i,i) = H_diag(i) + d(i);
  %H_y = diag(e);
  c_x = sigma - z .* hat_nu ./ g - s .* hat_tau ./ t;
  c_y = rho - e .* (hat_beta - q .* hat_alpha ./ p);
  
  % and solve the system [-H_x A'; A H_y] [delta_x, delta_y] = [c_x; c_y]
  % R = chol(H_x);
  % a_r = A / R;
  if (smw == 0) 
    c_r = c_x'/ R;
    H_tmp = a_r * a_r' + H_y;
    delta_y = H_tmp \ (c_y + a_r * c_r');
    delta_x = R \ (a_r' * delta_y - c_r');
  elseif (smw == 1)
    smw_c1 = c_x ./ d;			
    smw_c2 = (c_x - (H' * (smw_inner \ (smw_inner' \ (H * smw_c1)))))./d;
    
    delta_y = (A * smw_a2 + H_y) \ (c_y + A * smw_c2);
    delta_x = smw_a2 * delta_y - smw_c2;
  end;
  %backsubstitution
  delta_w = - e .* (hat_beta - q .* hat_alpha ./ p + delta_y);
  
  delta_s = s .* (delta_x - hat_tau) ./ t;
  delta_z = z .* (hat_nu - delta_x) ./ g;
  delta_q = q .* (delta_w - hat_alpha) ./ p;
  
  delta_v = v .* (gamma_w - delta_w) ./ w;
  delta_p = p .* (gamma_q - delta_q) ./ q;
  delta_g = g .* (gamma_z - delta_z) ./ z;
  delta_t = t .* (gamma_s - delta_s) ./ s;
  
  %compute the updates
  alfa = - (1 - optimizer.margin) / min([delta_g ./ g; delta_w ./ w; delta_t ./ t;
                    delta_p ./ p; delta_z ./ z; delta_v ./ v;
		    delta_s ./ s; delta_q ./ q; -1]);
  
  x = x + delta_x * alfa;
  g = g + delta_g * alfa;
  w = w + delta_w * alfa;
  t = t + delta_t * alfa;
  p = p + delta_p * alfa;
  y = y + delta_y * alfa;
  z = z + delta_z * alfa;
  v = v + delta_v * alfa;
  s = s + delta_s * alfa;
  q = q + delta_q * alfa;

  % these two lines put back in
  mu = (z' * g + v' * w + s' * t + p' * q)/(2 * (m + n));
  mu = mu * ((alfa - 1) / (alfa + 10))^2;

  mu = newmu;
end

if (optimizer.verbose > 0)			% final report
  report = sprintf('%i \t%e \t%e \t%e \t%e \t%e \t%e', ...
		   counter, primal_infeasibility, dual_infeasibility, ...
		   sigfig, alfa, primal_obj, dual_obj);    
  disp(report);
end

% repackage the results
primal = x;
dual   = y;

if ((sigfig > optimizer.sigfig) & (counter < optimizer.maxiter))
  how    = 'converged';
else					% must have run out of counts
  if ((primal_infeasibility > 10e5) & (dual_infeasibility > 10e5))
    how    = 'primal and dual infeasible';
  elseif (primal_infeasibility > 10e5)
    how    = 'primal infeasible';
  elseif (dual_infeasibility > 10e5)
    how    = 'dual infeasible';
  else					% don't really know
    how    = 'slow convergence, change bound?';
  end;
end









