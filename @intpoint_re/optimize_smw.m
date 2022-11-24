function [x, y] = optimize_smw(optimizer, c, H1mn, H1nn, H2, A, l, u)
%X = OPTIMIZE_SMW(c, H1mn, H1nn, H2, A, l, u)
%
%loqo solves the quadratic programming problem
%
%minimize   c' * x + 1/2 x' * H * x
%subject to A*x = 0
%           l <= x <= u
%
%here H has a special form: [(H2 + H1) (H2 - H1); (H2 - H1) (H2 + H1)]
%     H1 is assumed to be positive semidefinite full
%     H2 is defined by its diagonal elements (hence passed as a vector)
%     (this is useful for Regression Estimation)
%
%for a documentation see R. Vanderbei, LOQO: an Interior Point Code
%                        for Quadratic Programming

% the fudge factors
margin = 0.05;
bound  = 0.5;
sigfig_max = 8;
counter_max = 100;

% gather some starting data
[j nn] = size(A);
[m n] = size(H1mn);

b_plus_1 = 1;
c_plus_1 = norm(c) + 1;
one_x = -ones(nn,1);
one_y = -ones(j,1);

% starting point
d = ones(nn,1);
H_y = eye(j);
c_x = c;
c_y = 0;

% and solve the system [-H_x A'; A H_y] [x, y] = [c_x; c_y]

re_decom_smw;

%stupid but less writing necessary
y = x_y;
x = x_x;

g = max(abs(x - l), bound);
z = max(abs(x), bound);
t = max(abs(u - x), bound);
s = max(abs(x), bound);

mu = (z' * g + s' * t)/(2 * n);

% set some default values
sigfig = 0;
counter = 0;
alfa = 1;

%H1_full = H1mn * inv(H1nn) * H1mn';

if (optimizer.verbose > 0)	% print at least one status report
  report = sprintf(['Iter \tPrimalInf \tDualInf \tSigFigs ' ...
		    '\tRescale \tPrimalObj \tDualObj']); 
  disp(report);
end

while ((sigfig < sigfig_max) * (counter < counter_max)),

%update the iteration counter
counter = counter + 1;

%central path (predictor)
%H_dot_x = H * x;
x1 = x(1:m);
x2 = x((m+1):nn);

xjoin = [x1, x2];
h1xjoin = H1mn * ((xjoin' * H1mn) / H1nn)';
h1x1 = h1xjoin(:,1);
h1x2 = h1xjoin(:,2);
h2x1 = H2 .* x1;
h2x2 = H2 .* x2;
H_dot_x = [(h2x1 + h1x1 + h2x2 - h1x2); (h2x1 - h1x1 + h2x2 + h1x2)];

rho = - A * x;
nu = l - x + g;
tau = u - x - t;
sigma = c - A' * y - z + s + H_dot_x;

gamma_z = - z;
gamma_s = - s;

% instrumentation
x_dot_H_dot_x = x' * H_dot_x;

primal_infeasibility = norm([tau; nu]) / b_plus_1;
dual_infeasibility = norm([sigma]) / c_plus_1;

primal_obj = c' * x + 0.5 * x_dot_H_dot_x;
dual_obj = - 0.5 * x_dot_H_dot_x + l' * z - u' * s;

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
hat_nu = nu + g .* gamma_z ./ z;
hat_tau = tau - t .* gamma_s ./ s;

% the diagonal terms
d = z ./ g + s ./ t;

% initialization before the big cholesky
H_y = 0;
c_x = sigma - z .* hat_nu ./ g - s .* hat_tau ./ t;
c_y = rho;

% and solve the system [-H_x A'; A H_y] [delta_x, delta_y] = [c_x; c_y]

re_decom_smw;

delta_y = x_y;
delta_x = x_x;

%backsubstitution
delta_s = s .* (delta_x - hat_tau) ./ t;
delta_z = z .* (hat_nu - delta_x) ./ g;

delta_g = g .* (gamma_z - delta_z) ./ z;
delta_t = t .* (gamma_s - delta_s) ./ s;

%central path (corrector)
gamma_z = mu ./ g - z - delta_z .* delta_g ./ g;
gamma_s = mu ./ t - s - delta_s .* delta_t ./ t;

% some more intermediate variables (the hat section)
hat_nu = nu + g .* gamma_z ./ z;
hat_tau = tau - t .* gamma_s ./ s;

% the diagonal terms
%d = z ./ g + s ./ t;

% initialization before the big cholesky
H_y = 0;
c_x = sigma - z .* hat_nu ./ g - s .* hat_tau ./ t;
c_y = rho;

% and solve the system [-H_x A'; A H_y] [delta_x, delta_y] = [c_x; c_y]

re_decom_smw;

delta_y = x_y;
delta_x = x_x;

%backsubstitution

delta_s = s .* (delta_x - hat_tau) ./ t;
delta_z = z .* (hat_nu - delta_x) ./ g;

delta_g = g .* (gamma_z - delta_z) ./ z;
delta_t = t .* (gamma_s - delta_s) ./ s;

%compute the updates
alfa = - 0.95 / min([delta_g ./ g; delta_t ./ t;
                    delta_z ./ z; delta_s ./ s; -1]);

mu = (z' * g + s' * t)/(2 * nn);
mu = mu * ((alfa - 1) / (alfa + 10))^2;

x = x + delta_x * alfa;
g = g + delta_g * alfa;
t = t + delta_t * alfa;
y = y + delta_y * alfa;
z = z + delta_z * alfa;
s = s + delta_s * alfa;

end

if (optimizer.verbose > 0)			% final report
  report = sprintf('%i \t%e \t%e \t%e \t%e \t%e \t%e', ...
		   counter, primal_infeasibility, dual_infeasibility, ...
		   sigfig, alfa, primal_obj, dual_obj);    
  disp(report);
end

