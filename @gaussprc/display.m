function x = display(d)
%DISPLAY Basic template for the gaussian processes object
%	
%	X = DISPLAY(D) when called with an output argument prints out
%	the parameter setting which can be used with a logfile

% File:       @gaussprc/display.m
%
% Author:      Alexandros Karatzoglou, Alex J. Smola
% Created:     02/07/98
% Updated:     01/01/04
% 




if nargout == 0
	disp(sprintf(['Kernel used: ']));
	d.kernel

	disp(sprintf(['\nProblem Type: %s'], d.problem));
else
	x = ['_problem_', d.problem] 
	     
end;
	
