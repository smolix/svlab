function x = display(d)
%DISPLAY Basic template for the Dot Product display routine
%	
%	X = DISPLAY(D) when called with an output argument prints out
%	the parameter setting which can be used with a logfile

% File:        @bessel_dot/display.m
%
% Author:      Alex J. Smola
% Created:     01/12/98
% Updated:     14/11/02
%
% This code is released under the GNU Public License
% Copyright by GMD FIRST and The Australian National University

if nargout == 0
  if d.nu == -1
    nutemp = 'automatic';
  else
    nutemp = sprintf('%d', d.nu);
  end;
  tmp = sprintf(['Dot product\n' ...
		 'Type       \t: %s\n' ...
		 'Block size \t: %d\n' ...
		 'Sigma      \t: %d\n' ...
		 'Nu         \t: %s\n' ...
		 'n          \t: %d\n'], ...
		d.name, d.blocksize, d.sigma, nutemp, d.n);
  disp(tmp);
  d.blocksize;
else
  x = sprintf('%s_blocksize_%d_sigma_%d_nu_%d_n_%d', ...
	      d.name, d.blocksize, d.sigma, d.nu, d.n);
end
