function d = pr_smo(a)
%INTPOINT Pattern Recognition Optimizer
%
%  creates an optimizer object with all basic settings installed
%  (sigfig etc.)

% File:        @pr_smo/pr_smo.m
%
% Author:      Alexandros Karatzoglou 
% Created:     24/02/04
% Modified:    24/02/04
%
% This code is released under the GNU Public License
% Copyright by The Australian National University
%

if nargin == 0
 
 d.C  = 1;		
 d.epsilon = 1e-8;
 d.tol = 0.01;
 d.numchanged = 0;
 d.examineall = 1;  
 d.verbose = 0;                       
 d.counter = 0;
 d.filename = 'smo_state';	                        

elseif (nargin == 1) & isa(a, 'char')
  token = read_token(a, 'C');
  d.C = str2num(token);
  token = read_token(a, 'counter');
  d.counter = str2num(token);
  token = read_token(a, 'epsilon');
  d.epsilon = str2num(token);
  token = read_token(a, 'tol');
  d.tol = str2num(token);
  token = read_token(a, 'examineall');
  d.examineall = str2num(token);
  token = read_token(a, 'numchanged');
  d.numchanged = str2num(token);
  token = read_token(a, 'filename');
  d.filename = token;
  token = read_token(a, 'verbose');
  d.verbose = str2num(token);
else
  error('wrong type of arguments');
end

d = class(d, 'pr_smo');	

