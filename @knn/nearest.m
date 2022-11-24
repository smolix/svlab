function [distances,indices] = nearest(knn_obj, ker, ...
				       training_patterns, ...
				       test_patterns);
%function [distances,indices] = nearest(knn_obj, ker, ...
%				       training_patterns, test_patterns);
% for each test pattern, computes the distances and indices into the 
%   training_patterns matrix of the (knn_obj.num_features) closest
%   training patterns. [distances] is an array, size 
%   (numfeatures)*(num. test patterns), of distances under the
%   kernel 'ker', and the matrix [indices] is the column of
%   [test_patterns] for the corresponding test pattern.
%
% See also: @knn/knn.m
 
%
%
% File:        @knn/nearest.m
%
% Author:      Ben O'Loghlin
% Created:     10/09/00
% Updated:     04/04/01
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

num_neighbors = knn_obj.num_neighbors;
chunk_size = knn_obj.chunk_size; % how many test patterns to process in one run
verbose = knn_obj.verbose;

%get the sample size
[dim, num_train] = size(training_patterns);
[dim, num_test] = size(test_patterns);

% the main idea is to exploit 0.5 * ||x - y||^2 = 0.5 * x^2 + 0.5 * y^2 - x.y
train_2 = zeros(num_train, 1);
test_2 = zeros(num_test, 1);

if (verbose) disp('computing squares of training data'); end
  
for i = 1:num_train
  train_2(i) = 0.5 * (sv_dot(ker,training_patterns(:,i)));
end;

if (verbose) disp('computing squares of testing data'); end 
  
for i = 1:num_test
  test_2(i) = 0.5 * (sv_dot(ker,test_patterns(:,i)));
end;

if (verbose) disp('allocating memory for the dot products and labels');
end
  
distances = zeros(num_neighbors, num_test);
indices = zeros(num_neighbors, num_test);

%%%%%%%%%%%%%%%%%%%%%%%%loop for test data%%%%%%%%%%%%%%%%%%%%%%%%%%%
chunk_start = 1;
chunk_stop = chunk_size;
train_2_big = train_2 * ones(1,chunk_size);
current_chunk_size = chunk_size;

while chunk_start <= num_test
  if chunk_stop > num_test
    chunk_stop = num_test;
    current_chunk_size = chunk_stop - chunk_start + 1;
    train_2_big = train_2_big(:,1:current_chunk_size);
  end

  % main distance calculation using sv_dot
  closest = train_2_big + ...
      ones(num_train, 1) * test_2(chunk_start:chunk_stop)' - ...
      sv_dot(ker,training_patterns,test_patterns(:,chunk_start:chunk_stop)); 

  [sorted, index] = sort(closest);
  
  % put the answers in the appropriate chunk slot of the output matrices
  distances(:,chunk_start:chunk_stop) = sorted(1:num_neighbors,:);
  indices(:,chunk_start:chunk_stop) = index(1:num_neighbors,:);
  if (verbose) fprintf(1, '.'); end
  
  chunk_start = chunk_start + chunk_size;
  chunk_stop = chunk_stop + chunk_size;
  clear closest;

end

fprintf(' done\n');





