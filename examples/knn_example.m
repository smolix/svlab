% An example of how to use the kernel nearest neighbors routines
%
%
% File:        example/nearest_neighbors.m
%
% Author:      Ben O'Loghlin
% Created:     20/03/00
% Updated:     21/03/00
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up object orientation stuff
ker = tanh_dot;
%ker.degree = 2;
knn_obj = knn;         %create the object
knn_obj.num_neighbors = 16;  %get the 20 nearest neighbors to each test pattern
knn_obj.verbose = 1;        %let's be a bit verbose
knn_obj.chunk_size = 16;    %process test_patterns in chunks of 16

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate a toy data set

cluster_pos = [1 -1; ...
               1 -1]; % two clusters of data
cluster_size = 100;
sigma_noise = [0.5  0.5; ...
               0.5, 0.5]; % data clustered around centers with these std. devs
num_clusters = size(cluster_pos,2);
         
train_num = num_clusters*cluster_size;
test_patterns = 0.2*randn(2,100); % points to classify 
                                  %   - we create 100 but only plot one of them

   % create the points at the cluster centers and add noise 
training_patterns = zeros(2, train_num);
for i=1:num_clusters,
   training_patterns(:,(i-1)*cluster_size+1:i*cluster_size) ...
      = cluster_pos(:,i)*ones(1,cluster_size) + diag(sigma_noise(:,i))*randn(2,cluster_size);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% call the nearest neighbors routine
[distances, indices] = nearest(knn_obj,ker,training_patterns,test_patterns);

% use the index returned by 'nearest' to get a matrix of nearest neighbors
% for each of the first two test points
nearest_1 = training_patterns(:,indices(:,1)');

num_crosses = 0;
num_dots = 0;

for i=1:knn_obj.num_neighbors,
  if indices(i,1)>100
    num_dots = num_dots + 1;
  else
    num_crosses = num_crosses + 1;
  end
end

fprintf(1,'Out of %d nearest neighbors,\n', knn_obj.num_neighbors);
fprintf(1,'\tNumber of crosses = %d\n',num_crosses);
fprintf(1,'\tNumber of dots    = %d\n',num_dots);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the results
figure(1)
plot(training_patterns(1,1:cluster_size), ...
     training_patterns(2,1:cluster_size),'bx')
hold on
plot(training_patterns(1,cluster_size+1:2*cluster_size), ...
     training_patterns(2,cluster_size+1:2*cluster_size),'b.')

plot([1 -1],[1 -1],'rp');
plot([-3,3],[3,-3],'r:');
plot(test_patterns(1,1),test_patterns(2,1),'ks')
plot(nearest_1(1,:),nearest_1(2,:),'ko');
hold off


