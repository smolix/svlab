function x = display(d)
%DISPLAY Display routine for novelty detection objects
%	
%	X = DISPLAY(D) when called with an output argument prints out
%	the parameter setting which can be used with a logfile

% File:        @online_novelty/display.m
%
% Author:      Paul S. Wankadia, Alexandros Karatzoglou
% Created:     12/09/00
% Updated:     12/07/04
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

if nargout == 0
  tmp = sprintf('Type       \t: %s \nBuffer size \t: %d', d.name, d.bufsize);
  disp(tmp);
else
  x = sprintf('%s_bufsize_%d', d.name, d.bufsize);
end
