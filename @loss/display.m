function x = display(d)
%DISPLAY Basic template for the losss
%       
%       X = DISPLAY(D) when called with an output argument prints out
%       the parameter setting which can be used with a logfile

% File:        @loss/display.m
%
% Author:      Alex J. Smola
% Created:     07/03/01
% Updated:     
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

if nargout == 0
  tmp = sprintf('Loss Term: %s\n',  char(d.keywords(d.type)));
  disp(tmp);
else
  x = sprintf(char(d.keywords(d.type)));
end
