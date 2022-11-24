function x = display(d)
%DISPLAY Basic template for the data object
%	
%	X = DISPLAY(D) when called with an output argument prints out
%	the parameter setting which can be used with a logfile

% File:       @lsvm/display.m
%
% Author:      Alexandros Karatzoglou, Alex J. Smola
% Created:     02/07/04
% Updated:     02/07/04
% 




if nargout == 0
	disp(['Kernel']);
	d.kernel
	disp(['Problem Type: ', num2str(d.problemtype)]);
	disp(['nu parameter: ', num2str(d.nu)]);
	disp(['lambda parameter  : ', num2str(d.lambda)]);
	disp(['tolerance  : ', num2str(d.tol)]);
	disp(['maximum number of iterations  : ', num2str(d.itmax)]);
else
	x = ['problemtype_', d.problemtype, '_nu_', d.nu, ...
	     '_lambda_', d.lambda, '_tolerance_', d.tol, '_iterations_', num2str(d.itmax)];
end;
	
