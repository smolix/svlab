% Kernel PCA toy example for k(x,y)=exp(-||x-y||^2/rbf_var), cf. Fig. 4 in 
% @article{SchSmoMue98,
%   author    = "B.~{Sch\"olkopf} and A.~Smola and K.-R.~{M\"uller}",
%   title     = "Nonlinear component analysis as a kernel Eigenvalue problem",
%   journal =    {Neural Computation},
%   volume    = 10,
%   issue     = 5,
%   pages     = "1299 -- 1319",
%   year      = 1998}
% Last modified: 18 Sept 2000 (jo)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% same algorithm as Bernhard.m (i.e. same as kpca rbf toy problem in
% www.kernel-machines.org Software/Other section), but solution implemented
% with svlab/@kpca/ functions.

% parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rbf_var = 0.1;
xnum = 4;
ynum = 2;
max_ev = xnum*ynum;
% (extract features from the first <max_ev> Eigenvectors)
x_test_num = 15;
y_test_num = 15;
cluster_pos = [-0.5 -0.2; 0 0.6; 0.5 0];
cluster_size = 30;

% generate a toy data set
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_clusters = size(cluster_pos,1);
train_num = num_clusters*cluster_size;
patterns = zeros(train_num, 2);
range = 1;
randn('seed', 0);
for i=1:num_clusters,
  patterns((i-1)*cluster_size+1:i*cluster_size,1) = cluster_pos(i,1)+0.1*randn(cluster_size,1);
  patterns((i-1)*cluster_size+1:i*cluster_size,2) = cluster_pos(i,2)+0.1*randn(cluster_size,1);
end
test_num = x_test_num*y_test_num;
x_range = -range:(2*range/(x_test_num - 1)):range;
y_offset = 0.5;
y_range = -range+ y_offset:(2*range/(y_test_num - 1)):range+ y_offset;
[xs, ys] = meshgrid(x_range, y_range);
test_patterns(:, 1) = xs(:);
test_patterns(:, 2) = ys(:);
cov_size = train_num;  % use all patterns to compute the covariance matrix

% carry out Kernel PCA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kp = kpca;
kp.numfeatures=max_ev;
kernel = rbf_dot(1/rbf_var);
[e_vals, e_vecs, offset] = train(kp, kernel, patterns');


% extract features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  do not need the following here - only need test point features
%unit_train = ones(train_num,cov_size)/cov_size;
%for i=1:train_num,
%  for j=1:cov_size,
%    K_train(i,j) = exp(-norm(patterns(i,:)-patterns(j,:))^2/rbf_var);
%  end
%end
%K_train_n = K_train - unit_train*K - K_train*unit + unit_train*K*unit;
%features = zeros(train_num, max_ev);
%features = K_train_n * evecs(:,1:max_ev);

test_features=extract(kp,kernel,patterns',test_patterns',offset,e_vecs,e_vals);

% plot it
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2); clf
for n = 1:max_ev,
  subplot(ynum, xnum, n);
  axis([-range range -range+y_offset range+y_offset]);
  imag = reshape(test_features(:,n), y_test_num, x_test_num);
  axis('xy')
  colormap(gray);
  hold on;
  pcolor(x_range, y_range, imag);
  shading interp
  contour(x_range, y_range, imag, 9, 'b');
  plot(patterns(:,1), patterns(:,2), 'r.')
  text(-1,1.65,sprintf('Eigenvalue=%4.3f', e_vals(n)));
  hold off;
end




