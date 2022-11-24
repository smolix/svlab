function x = display(d)
%DISPLAY Basic template for the optimizer routines of the knn family
%	
%	X = DISPLAY(D) when called with an output argument prints out
%	the parameter setting which can be used with a logfile

% File:        @knn/display.m
%
% Author:      Alex J. Smola / Ben O'Loghlin
% Created:     18/01/98
% Updated:     04/04/01
%
% This code is released under the GNU Public License
% Copyright The Australian National University

if nargout == 0
  tmp = sprintf(['KNN object\n' ...
		 'Number of Nearest Neighbor points\t%d\n'
		 'Chunk size\t: %d\n' ...
		 'Verbosity\t: %d'], ...
		d.num_neighbors, d.chunk_size, d.verbose);
  disp(tmp);
else
  x = sprintf('numneighbors_%d', ...
	      d.num_neighbors);
end
