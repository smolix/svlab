function d = kfa(varargin)
%SGMA Basic template for kfa approximators
%
%With no input arguments, creates a kfa object with all basic
%settings installed.
%
%Full constructor called as
%   x=kfa(verbose,sigfig,subsetsize)
%where verbose = 0 is quiet, (sigfig not implemented), subsetsize
%of 59 works well, 
% 
% See also: @kfa/train.m

% File:        @kfa/kfa.m
%
% Author:    Alexandros Karatzoglou
% Created: 02/08/04   
% Modified:  
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

%


varlist = {'kernel', 'features', 'subsetsize', 'normalized', 'sigfig', 'verbose',};
	   


emptystring = '';
defaults = {rbf_dot, 0, 59, 1, 7, 0};





d = cell2struct(defaults, varlist, 2);
d = read_param(varargin, d,varlist,defaults);


d.alpha = [];
d.indx = [];

d.x = [];



d = class(d, 'kfa');

