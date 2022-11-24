function save(d, flag)
%SAVE Save data and/or parameter part of d
%	
%	SAVE(D, FLAG) 
%	FLAG : [] or not existent - save all
%	       {data, parameter} save only this part of the data

% File:        @data/save.m
%
% Author:      Alex J. Smola
% Created:     02/07/98
% Updated:     
% 
% Copyright (c) 1998  GMD Berlin - All rights reserved
% THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of GMD Berlin
% The copyright notice above does not evidence any
% actual or intended publication of this work.

prefix = [d.info.savepath, d.info.filename];

if (nargin == 1) | isempty(flag) | equal(flag, 'parameter')
	d_info = d.info;		% workaround matlab bug (can't look into objects)
	save([prefix, '_info.mat'], 'd_info');
end;

if (nargin == 1) | isempty(flag) | equal(flag, 'data')
  if equal(d.info.format, 'matlab')
    save([prefix, '_data.mat'], 'd');
  elseif equal(d.info.format, 'sn')
    savesn(d.train.patterns, [prefix, '_train_patterns.mat']);
    savesn(d.train.labels, [prefix, '_train_labels.mat']);
    savesn(d.train.permute, [prefix, '_train_permute.mat']);
    savesn(d.valid.patterns, [prefix, '_valid_patterns.mat']);
    savesn(d.valid.labels, [prefix, '_valid_labels.mat']);
    savesn(d.valid.permute, [prefix, '_valid_permute.mat']);
    savesn(d.test.patterns, [prefix, '_test_patterns.mat']);
    savesn(d.test.labels, [prefix, '_test_labels.mat']);
    savesn(d.test.permute, [prefix, '_test_permute.mat']);

    savesn(d.std, [prefix, '_std.mat']);
    savesn(d.mean, [prefix, '_mean.mat']);
    savesn(d.pca, [prefix, '_pca.mat']);

  else
    disp('unknown file format for saving');
  end;
end;