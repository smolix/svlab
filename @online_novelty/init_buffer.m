function init_buffer(s, d)
%INIT_BUFFER Initialise the buffer for novelty detection
%
%	INIT_BUFFER(S, D) initialises the [global] variables for novelty
%	detection where S is an online_novelty object and D is the intended
%	dimensionality of the buffer.

% File:        @online_novelty/init_buffer.m
%
% Author:      Paul S. Wankadia
% Created:     12/09/00
% Updated:     12/09/00
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

% online_novelty global variables
global SVLAB_ONLINE_ALPHA
global SVLAB_ONLINE_DATA
global SVLAB_ONLINE_KAPPA
global SVLAB_ONLINE_RHO
global SVLAB_ONLINE_START
global SVLAB_ONLINE_STOP

if (nargin ~= 2)
  error('wrong number of arguments');
else
  % set to initial and default values
  % any changes here should be mirrored in clear_buffer.m
  SVLAB_ONLINE_ALPHA = zeros(s.bufsize,1);
  SVLAB_ONLINE_DATA = zeros(d,s.bufsize);
  SVLAB_ONLINE_KAPPA = 1;
  SVLAB_ONLINE_RHO = 0;
  SVLAB_ONLINE_START = 1;
  SVLAB_ONLINE_STOP = 1;
end
