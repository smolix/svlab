% online_novelty_train.m
% 
% training on usps data using online_novelty
% can be called repeatedly because it doesn't reset state

global iterations;

LAMBDA = 0.5;
nu = 0.01;
%nu = 0.005;
kernel = rbf_dot;
kernel.sigma = 1/(0.5 * n);

tally_done = 0;
rand('state', sum(100*clock));
[dummy, randindex] = sort(rand(m,1));
%for i = 1:m
for i = randindex'
  iterations = iterations + 1;
  lambda = LAMBDA / sqrt(iterations);
  train(nov, kernel, train_patterns(:,i), lambda, nu);
  tally_done = tally_done + 1;
  % logging
  if (mod(tally_done, 100) == 0)
    fprintf('\t%d\t%d\t%.4f\n', tally_done, SVLAB_ONLINE_STOP, ...
		SVLAB_ONLINE_RHO);
  end
end

% one more pass through the bad guys
fvals = sv_mult(kernel, train_patterns, SVLAB_ONLINE_DATA, ...
		SVLAB_ONLINE_ALPHA) - SVLAB_ONLINE_RHO;

figure(2);

[fvals, index] = sort(fvals);

for i = 1:50
  subplot(7, 10, i);
  colormap(gray);
  pcolor(rot90(reshape((1-train_patterns(:,index(i))),16,16)));
  axis off;
  shading('interp');
end
