function d = sgma(a)
%SGMA Basic template for sparse greedy matrix approximators
%
%With no input arguments, creates an sgma object with all basic
%settings installed.
%
%Full constructor called as
%   x=sgma(verbose,sigfig,maxiter,subsetsize,errorbound,blocksize)
%where verbose = 0 is quiet, (sigfig not implemented), subsetsize
%of 59 works well, errorbound is the bound on the residual error as
%a fraction of trace_K, and blocksize should be a power of 2.
% 
% See also: @sgma/train.m

% File:        @sgma/sgma.m
%
% Author:      Ben O'Loghlin
% Created:     25/9/00
% Modified:    5/10/00
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

d.name      = 'generic';
%
if nargin == 0
  d.verbose = 0;  %default to quiet mode
  d.sigfig = 7;   %significant figures
  d.maxiter = 100;
  d.subsetsize=59;
  d.errorbound = 0.01;
  d.blocksize = 0;
elseif (nargin == 1) & isa(a, 'char')
  token = read_token(a, 'verbose');
  d.verbose = str2num(token);
  token = read_token(a, 'sigfig');
  d.sigfig = str2num(token);
  token = read_token(a, 'maxiter');
  d.maxiter = str2num(token);
  token = read_token(a, 'subsetsize');
  d.subsetsize = str2num(token);
  token = read_token(a, 'errorbound');
  d.errorbound = str2num(token);
  token = read_token(a, 'blocksize');
  d.blocksize = str2num(token);
else
  error('wrong type of arguments');
end

d = class(d, 'sgma');		% make it a class








