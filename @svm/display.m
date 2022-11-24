function x = display(d)
%DISPLAY Basic template for the data object
%	
%	X = DISPLAY(D) when called with an output argument prints out
%	the parameter setting which can be used with a logfile

% File:       @svm/display.m
%
% Author:      Alexandros Karatzoglou, Alex J. Smola
% Created:     02/07/98
% Updated:     05/05/02
% 




if nargout == 0
	disp(['Kernel']);
	d.kernel
	disp(['Support Vector Type: ', num2str(d.type)]);
	disp(['Problem Type: ', num2str(d.problem)]);
	disp(['C parameter: ', num2str(d.c)]);
	disp(['Nu parameter  : ', num2str(d.nu)]);
	disp(['Epsilon  : ', num2str(d.epsilon)]);
else
	x = ['type_', d.type, '_problem_', d.problem, ...
	     '_c_', d.c, '_nu_', d.nu, '_Eps_', num2str(d.epsilon)];
end;
	
