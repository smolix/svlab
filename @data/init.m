function d = init(d)
%INIT initialize the dataset
%	
%	INIT(D) initializes the dataset, i.e. it performs pca,
%	permutations, and shuffling if necessary

% File:        @data/init.m
%
% Author:      Alex J. Smola, Alexandros Karatzoglou
% Created:     02/07/98
% Updated:     24/11/02
% 
% Copyright (c) 1998  GMD Berlin and ANU- All rights reserved
% THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of GMD Berlin
% The copyright notice above does not evidence any
% actual or intended publication of this work.

if isempty(d.train.patterns) || isempty(d.train.labels)
  disp('Training data incomplete, aborting initialization');
else
  d.train.size = size(d.train.patterns, 2);
  d.valid.size = size(d.valid.patterns, 2);
  d.test.size = size(d.test.patterns, 2);
  d.train.dim  = size(d.train.patterns, 1);
  d.train.outdim = size(d.train.labels, 1);
  d.valid.dim = size(d.train.patterns, 1);
  d.test.dim = size(d.train.labels, 1);
  
 
  % perform consistency check
  abort = 0;
  if (d.train.size ~= size(d.train.labels, 2))
    disp('Training data and labels have different size')
    abort = 1; 
  end;
  if d.valid.size ~= 0 
    abort = abort || consistent('Validation', d.train, d.valid);
  end;
  if d.test.size ~= 0 
    abort = abort || consistent('Test', d.train, d.test);
  end;
  
  % otherwise we already got an error message
  if abort == 0				
    d.train = setup_data(d.train,d);
    if d.test.size > 0
      d.test = setup_data(d.test,d);
    end;
    if d.valid.size > 0
      d.valid = setup_data(d.valid,d);
    end;
  end;
end;

d=d;
function data = setup_data(data,d);

if d.info.zeromean 
  dmean = mean(data.patterns, 2);
  for i=1:data.dim
   data.patterns(i,:) = data.patterns(i,:) - dmean(i,:);
  end;
end
if d.info.unitvariance
  dstd = std(data.patterns, 0, 2);
  for i=1:data.dim
    data.patterns(i,:) = data.patterns(i,:) / dstd(i,:);
  end;
end;
if d.info.unitrange
  drange = max(data.patterns, [], 2) - min(data.patterns, [], 2);
  for i=1:data.dim
    data.patterns(i,:) = (data.patterns(i,:) - min(data.paterns(i,:)))/drange(i,:);
  end;
end;
if d.info.pca
   dcov = cov(data.patterns');
  data.patterns = chol(dcov) \ data.patterns;
end;
if d.info.permute
  data.permute = randperm(data.size);
  data.patterns = data.patterns(:,data.permute);
  data.labels = data.labels(:,data.permute);
end;

data = data;

function breaks = consistent(dataname, data1, data2);

breaks = 0;
if (data1.size ~= size(data2.patterns, 2))
  disp([dataname, ' data and training data have different size']); breaks = 1; 
end;
if (data1.size ~= size(data2.labels, 2))
  disp([dataname, ' data (labels) and training data have different size']); breaks = 1; 
end;
if (data1.dim ~= size(data2.patterns, 1))
  disp([dataname, ' data and training data have different dimension']); breaks = 1; 
end;
if (data1.testdim ~= size(data2.labels, 1))
  disp([dataname, ' data (labels) and training data have different dimension']); breaks = 1; 
end;

