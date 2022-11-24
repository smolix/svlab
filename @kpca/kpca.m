function d = kpca(a)
%INTPOINT Basic template for kernel PCA optimizers
%
%  creates an optimizer object with all basic settings installed
%  (sigfig etc.)
%
% See Also @kpca/train.m, @kpca/extract.m

% File:        @kpca/kpca.m
%
% Author:      Alex J. Smola, Ben O'Loghlin
% Created:     01/18/98
% Modified:    21/09/00
%
% This code is released under the GNU Public License
% Copyright by The Australian National University


%
if nargin == 0
  d.verbose = 0;			% by default we're quiet
  d.numfeatures = 0;			% default is to use all
                                        % data
					
elseif (nargin == 2) & isa(a, 'char')
  token = read_token(a, 'verbose');
  d.verbose = str2num(token);
  token = read_token(a, 'numfeatures');
  d.numfeatures = str2num(token);
else
  error('wrong type of arguments');
end

d = class(d, 'kpca');		% make it a class


