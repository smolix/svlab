function d = online_novelty(a)
%ONLINE_NOVELTY Novelty detection constructor
%
%	d = online_novelty creates an object for novelty detection

% File:        @online_novelty/online_novelty.m
%
% Author:      Paul S. Wankadia, Alexandros Karatzoglou
% Created:     12/09/00
% Modified:    15/06/04
%
% This code is released under the GNU Public License
% Copyright by The Australian National University



d.name      = 'online_novelty';
if nargin == 0
  d.bufsize = 1000;		% buffer size for patterns
  d.dim = 0;           %dimensionality of data
elseif (nargin == 1) & isa(a, 'char')
  token = read_token(a, 'bufsize');
  d.bufsize = str2num(token);
   token = read_token(a, 'dim');
  d.dim = str2num(token);
elseif (nargin == 1) & isa(a, 'double')
  d.bufsize = a;
elseif (nargin
else
  error('wrong type of arguments');
end

d.online_alpha = zeros(d.bufsize,1);
d.online_data = [];
%%SVLAB_ONLINE_KAPPA = 1;
d.online_rho = 0;
d.online_start = 1;
d.online_stop = 1;

d = class(d, 'online_novelty');		% make it a class
