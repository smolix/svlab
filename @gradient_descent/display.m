function x = display(d)
%DISPLAY Basic template for the gradient_descent
%       
%       X = DISPLAY(D) when called with an output argument prints out
%       the parameter setting which can be used with a logfile

% File:        @gradient_descent/display.m
%
% Author:      Alex J. Smola
% Created:     07/03/01
% Updated:     
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

if nargout == 0
  tmp = sprintf('Gradient_Descent Type: %s\n',  char(d.keywords(d.type)));
  disp(tmp);
else
  x = sprintf(char(d.keywords(d.type)));
end
