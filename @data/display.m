function x = display(d)
%DISPLAY Basic template for the data object
%	
%	X = DISPLAY(D) when called with an output argument prints out
%	the parameter setting which can be used with a logfile

% File:        @data/display.m
%
% Author:      Alex J. Smola
% Created:     02/07/98
% Updated:     
% 
% Copyright (c) 1998  GMD Berlin - All rights reserved
% THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE of GMD Berlin
% The copyright notice above does not evidence any
% actual or intended publication of this work.

if nargout == 0
	disp(['Parameters']);
	disp(d.info);
	disp(['Training   set size: ', num2str(d.train.size)]);
	disp(['Validation set size: ', num2str(d.valid.size)]);
	disp(['Test       set size: ', num2str(d.test.size)]);
	disp(['Input  Dimensions  : ', num2str(d.train.dim)]);
	disp(['Output Dimensions  : ', num2str(d.train.outdim)]);
else
	x = ['name_', d.info.name, '_format_', d.info.format, ...
	     '_problemtype_', d.info.problemtype, '_filename_', d.info.filename, ...
	     '_loadpath_', d.info.loadpath, '_savepath_', d.info.savepath, ...
	     '_standardize_', num2str(d.info.standardize), ...
	     '_permute_', num2str(d.info.permute), ...
	     '_pca_', num2str(d.info.pca)];
end;
	
