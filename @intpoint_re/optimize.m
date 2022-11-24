function [x, y] = optimize(optimizer, c, H1, H2, A, b, l, u)
%X = optimize(optimizer, c, H1, H2, A, l, u)
%
%loqo solves the quadratic programming problem
%
%minimize   c' * x + 1/2 x' * H * x
%subject to A*x = b
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
[n n] = size(H1);

%some intermediate saving
H1_diag = diag(H1);

b_plus_1 = 1;
c_plus_1 = norm(c) + 1;
one_x = -ones(nn,1);
one_y = -ones(j,1);

% starting point
d = ones(nn,1);
H_y = eye(j);
c_x = c;
c_y = b;

% and solve the system [-H_x A'; A H_y] [x, y] = [c_x; c_y]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%re_decom PASTED INTO THE CODE - matlab oo makes code much less readable 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%solve the smaller problem (upper left block) first
c1 = [A(:,1:n)' c_x(1:n,:)];
c2 = [A(:,(n+1):nn)' c_x((n+1):nn,:)];
c_plus = c1 + c2;
c_minus = c1 - c2;

D1 = d(1:n);
D2 = d((n+1):nn);

%diagonal terms
T_plus  = 0.5 * (D1 + D2);
T_minus = 0.5 * (D1 - D2);
T       = 1 ./ (2 * H2 + T_plus);
TTminus = T .* T_minus;
T_diag  = H1_diag + 0.5 * (T_plus - T_minus .* TTminus);

for i = 1:(j + 1)
	rhs_int(:,i) = 0.5 * (c_minus(:,i) - TTminus .* c_plus(:,i));
end

for i = 1:n
	H1(i,i) = T_diag(i);
end
R = chol(H1);
Hx_AC_minus = R \ (rhs_int' / R)';

for i = 1:(j + 1)
	Hx_AC_plus(:,i) = T .* (c_plus(:,i) - T_minus .* Hx_AC_minus(:,i));
end

Hx_AC = 0.5 * [(Hx_AC_plus + Hx_AC_minus); (Hx_AC_plus - Hx_AC_minus)];
A_Hx_AC = A * Hx_AC;

%split up the indices and substitute back
Hx_A = Hx_AC(:,1:j);
Hx_C = Hx_AC(:,j+1);
A_Hx_A = A_Hx_AC(:,1:j);
A_Hx_C = A_Hx_AC(:,j+1);

x_y = (A_Hx_A + H_y) \ (c_y + A_Hx_C);
x_x = (Hx_A * x_y) - Hx_C;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%re_decom PASTED INTO THE CODE - matlab oo makes code much less readable 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%stupid but less writing necessary
y = x_y;
x = x_x;

g = max(abs(x - l), bound);
z = max(abs(x), bound);
t = max(abs(u - x), bound);
s = max(abs(x), bound);

%disp('x'); pprint(x);
%disp('y'); pprint(y);
%disp('g'); pprint(g);
%disp('z'); pprint(z);
%disp('t'); pprint(t);
%disp('s'); pprint(s);


mu = (z' * g + s' * t)/(2 * n);

% set some default values
sigfig = 0;
counter = 0;
alfa = 1;

while ((sigfig < sigfig_max) & (counter < counter_max)),
 
  %update the iteration counter
  counter = counter + 1;

  %central path (predictor)
  %H_dot_x = H * x;
  %first put H1_diag back in place
  for i = 1:n
    H1(i,i) = H1_diag(i);
  end
  x1 = x(1:n);
  x2 = x((n+1):nn);
  h1x1 = H1 * x1;
  h1x2 = H1 * x2;
  h2x1 = H2 .* x1;
  h2x2 = H2 .* x2;
  H_dot_x = [(h2x1 + h1x1 + h2x2 - h1x2); (h2x1 - h1x1 + h2x2 + h1x2)];

  %disp('h_dot_x'); pprint(H_dot_x);
  
  rho = - A * x + b;
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

  report = sprintf('counter %i p_i %e d_ii %e sigfig %f, alpha %f, p_o %f d_o %f mu %e', counter, primal_infeasibility, dual_infeasibility, sigfig, alfa, primal_obj, dual_obj, mu);
										    %disp(report);

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

   %disp('sigma'); pprint(sigma);
   %disp('hat_nu'); pprint(hat_nu);
   %disp('hat_tau'); pprint(hat_tau);

   %disp('d'); pprint(d);
   %disp('rhs'); pprint(c_x); pprint(c_y);

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %re_decom PASTED INTO THE CODE - matlab oo makes code much less readable 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %solve the smaller problem (upper left block) first
   c1 = [A(:,1:n)' c_x(1:n,:)];
   c2 = [A(:,(n+1):nn)' c_x((n+1):nn,:)];
   c_plus = c1 + c2;
   c_minus = c1 - c2;

   D1 = d(1:n);
   D2 = d((n+1):nn);

   %diagonal terms
   T_plus  = 0.5 * (D1 + D2);
   T_minus = 0.5 * (D1 - D2);
   T       = 1 ./ (2 * H2 + T_plus);
   TTminus = T .* T_minus;
   T_diag  = H1_diag + 0.5 * (T_plus - T_minus .* TTminus);

   for i = 1:(j + 1)
     rhs_int(:,i) = 0.5 * (c_minus(:,i) - TTminus .* c_plus(:,i));
   end

   for i = 1:n
     H1(i,i) = T_diag(i);
   end
   R = chol(H1);
   Hx_AC_minus = R \ (rhs_int' / R)';

   for i = 1:(j + 1)
     Hx_AC_plus(:,i) = T .* (c_plus(:,i) - T_minus .* Hx_AC_minus(:,i));
   end

   Hx_AC = 0.5 * [(Hx_AC_plus + Hx_AC_minus); (Hx_AC_plus - Hx_AC_minus)];
   A_Hx_AC = A * Hx_AC;

   %split up the indices and substitute back
   Hx_A = Hx_AC(:,1:j);
   Hx_C = Hx_AC(:,j+1);
   A_Hx_A = A_Hx_AC(:,1:j);
   A_Hx_C = A_Hx_AC(:,j+1);

   x_y = (A_Hx_A + H_y) \ (c_y + A_Hx_C);
   x_x = (Hx_A * x_y) - Hx_C;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %re_decom PASTED INTO THE CODE - matlab oo makes code much less readable 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   delta_y = x_y;
   delta_x = x_x;

   %disp('delta_x'); pprint(delta_x);
   %disp('delta_y'); pprint(delta_y);

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

   %disp('rhs'); pprint(c_x); pprint(c_y);

   % and solve the system [-H_x A'; A H_y] [delta_x, delta_y] = [c_x; c_y]

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %re_decom PASTED INTO THE CODE - matlab oo makes code much less readable 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %solve the smaller problem (upper left block) first
   c1 = [A(:,1:n)' c_x(1:n,:)];
   c2 = [A(:,(n+1):nn)' c_x((n+1):nn,:)];
   c_plus = c1 + c2;
   c_minus = c1 - c2;

   D1 = d(1:n);
   D2 = d((n+1):nn);

   %diagonal terms
   T_plus  = 0.5 * (D1 + D2);
   T_minus = 0.5 * (D1 - D2);
   T       = 1 ./ (2 * H2 + T_plus);
   TTminus = T .* T_minus;
   T_diag  = H1_diag + 0.5 * (T_plus - T_minus .* TTminus);

   for i = 1:(j + 1)
     rhs_int(:,i) = 0.5 * (c_minus(:,i) - TTminus .* c_plus(:,i));
   end

   for i = 1:n
     H1(i,i) = T_diag(i);
   end
   R = chol(H1);
   Hx_AC_minus = R \ (rhs_int' / R)';

   for i = 1:(j + 1)
     Hx_AC_plus(:,i) = T .* (c_plus(:,i) - T_minus .* Hx_AC_minus(:,i));
   end

   Hx_AC = 0.5 * [(Hx_AC_plus + Hx_AC_minus); (Hx_AC_plus - Hx_AC_minus)];
   A_Hx_AC = A * Hx_AC;

   %split up the indices and substitute back
   Hx_A = Hx_AC(:,1:j);
   Hx_C = Hx_AC(:,j+1);
   A_Hx_A = A_Hx_AC(:,1:j);
   A_Hx_C = A_Hx_AC(:,j+1);
   
   x_y = (A_Hx_A + H_y) \ (c_y + A_Hx_C);
   x_x = (Hx_A * x_y) - Hx_C;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %re_decom PASTED INTO THE CODE - matlab oo makes code much less readable 
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   delta_y = x_y;
   delta_x = x_x;

   %disp('delta_x'); pprint(delta_x);
   %disp('delta_y'); pprint(delta_y);

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

%disp('x'); pprint(x);
%disp('y'); pprint(y);



