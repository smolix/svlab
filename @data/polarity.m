function x = polarity(d, pos, neg)
%POLARITY compute polarities (1 and -1) for a given dataset and index set
%	
%	POLARITY(D, POS, NEG) computes indices for a given dataset

% File:        @data/polarity.m
%
% Author:      Alex J. Smola
% Created:     02/07/98
% Updated:     
% 
% Copyright (c) 1998  GMD Berlin - All rights reserved
% THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of GMD Berlin
% The copyright notice above does not evidence any
% actual or intended publication of this work.

%consistency checking
if (max([pos, neg]) > d.train.testdim)
  disp('error: inconsistent labes requested for polarities');
else
  if isempty(x.train.labels) == 0
    x.train = sum(d.train.labels(pos,:),2) - ...
	sum(d.train.labels(neg,:),2);
  else
    x.train = [];
  end;
  if isempty(x.test.labels) == 0
    x.test = sum(d.test.labels(pos,:),2) - ...
	sum(d.test.labels(neg,:),2);
  else
    x.test = [];
  end;
  if isempty(x.valid.labels) == 0
    x.valid = sum(d.valid.labels(pos,:),2) - ...
	sum(d.valid.labels(neg,:),2);
  else
    x.valid = [];
  end;
end;
