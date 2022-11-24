function [kii_est_, x_sub_, kmn_, knn_, T_, Z_] = ...
    add_pattern(kii, kii_est, x, kernel, n, x_sub, kmn, knn, T, Z)
%
%
%
kdiff = kii - kii_est;
[dummy, i_hat] = max(abs(kdiff));  % do we need the abs() here ??
x_i = x(:, i_hat);
k = kii(i_hat);

% Next column of kmn
k_np1 = sv_dot(kernel, x, x_i);

if n == 0
  knn_ = k;
  tau = sqrt(k);
  T_ = tau;
  v = k_np1' ./ tau;
  Z_ = v;
else
  k_bar = sv_dot(kernel, x_sub, x_i)';
  knn_ = [knn k_bar'; k_bar k];
  t_bar = (T \ k_bar')';
  tau = sqrt(k - t_bar*t_bar');
  % Sanity check
  if imag(tau) ~= 0
    error('tau is complex');
  end
  T_ = [T zeros(n, 1); t_bar tau];
  foo = T \ kmn';
  v = 1/tau * (-t_bar * foo + k_np1');
  Z_ = [foo; v];
end

kmn_ = [kmn k_np1];
kii_est_ = kii_est + v.*v;
x_sub_ = [x_sub x_i];