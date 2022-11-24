function d = knn(a)
%INTPOINT Basic template for kernel nearest neighbors objects
%
%  creates a knn object with all basic settings installed
%  (sigfig etc.)
%
% See Also @knn/nearest.m

% File:        @knn/knn.m
%
% Author:      Alex J. Smola, Ben O'Loghlin
% Created:     18/01/98
% Modified:    04/04/01
%
% This code is released under the GNU Public License
% Copyright by The Australian National University


%
if nargin == 0
  d.num_neighbors = 64; %number of nearest neighbors to find
  d.verbose = 0;	% by default we're quiet
  d.chunk_size = 128;	% default is to process in chunks of 128
                        % test points
					
elseif (nargin == 2) & isa(a, 'char')
  token = read_token(a, 'num_neighbors');
  d.num_neighbors = str2num(token);
  token = read_token(a, 'chunk_size');
  d.chunk_size = str2num(token);
  token = read_token(a, 'verbose');
  d.verbose = str2num(token);
else
  error('wrong type of arguments');
end

d = class(d, 'knn');		% make it a class


