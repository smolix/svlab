function d = load(d, flag)
%LOAD Load data and/or parameter part of d
%	
%	LOAD(D, FLAG) 
%	FLAG : [] or not existent - load all
%	       {data, parameter} load only this part of the data

% File:        @data/load.m
%
% Author:      Alex J. Smola
% Created:     02/07/98
% Updated:     
% 
% Copyright (c) 1998  GMD Berlin - All rights reserved
% THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of GMD Berlin
% The copyright notice above does not evidence any
% actual or intended publication of this work.

prefix = [d.info.loadpath, d.info.filename];

if (nargin == 1) | isempty(flag) | equal(flag, 'parameter')
  load([prefix, '_info.mat'], 'd_info');
  d.info = d_info;			% workaround matlab bug (can't look into objects)
end;

if (nargin == 1) | isempty(flag) | equal(flag, 'data')
  if equal(d.info.format, 'matlab')
    load([prefix, '_data.mat']);
  elseif equal(d.info.format, 'sn')
    d.train.patterns = loadsn([prefix, '_train_patterns.mat']);
    d.train.labels = loadsn([prefix, '_train_labels.mat']);
    d.train.permute = loadsn([prefix, '_train_permute.mat']);
    d.valid.patterns = loadsn([prefix, '_valid_patterns.mat']);
    d.valid.labels = loadsn([prefix, '_valid_labels.mat']);
    d.valid.permute = loadsn([prefix, '_valid_permute.mat']);
    d.test.patterns = loadsn([prefix, '_test_patterns.mat']);
    d.test.labels = loadsn([prefix, '_test_labels.mat']);
    d.test.permute = loadsn([prefix, '_test_permute.mat']);

    d.std = loadsn([prefix, '_std.mat']);
    d.mean = loadsn([prefix, '_mean.mat']);
    d.pca = loadsn([prefix, '_pca.mat']);

    d.train.size = size(d.train.patterns, 2);
    d.train.patdim = size(d.train.patterns, 1);
    d.train.testdim = size(d.train.labels, 1);
    d.valid.size = size(d.valid.patterns, 2);
    d.test.size = size(d.test.patterns, 2);
    
  else
    disp('unknown file format for saving');
  end;
end;