function clear_buffer(s)
%CLEAR_BUFFER Clears (resets) the buffer for novelty detection
%
%	CLEAR_BUFFER(S) clears (resets) the [global] variables for novelty
%	detection where S is an online_novelty object.

% File:        @online_novelty/clear_buffer.m
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

if (nargin ~= 1)
  error('wrong number of arguments');
else
  % reset to initial and default values as per init_buffer.m
% $$$   SVLAB_ONLINE_ALPHA = zeros(s.bufsize,1);
% $$$   SVLAB_ONLINE_DATA = zeros(size(SVLAB_ONLINE_DATA,1),s.bufsize);
  SVLAB_ONLINE_ALPHA = [];
  SVLAB_ONLINE_DATA = [];
  SVLAB_ONLINE_KAPPA = 1;
  SVLAB_ONLINE_RHO = 0;
  SVLAB_ONLINE_START = 1;
  SVLAB_ONLINE_STOP = 1;
end
