function gp = train(gp,d,y)
% gp = train(gp,d,y)
% Example code for training Gaussian processes.
% 
% SV = TRAIN(SV,D,Y) returns a trained Gaussian Processes Object (alphas) 
%                    SV is a gaussian processes object,
%                    D is a data object or the patterns matrix or the patterns
%                    Y is the labels matrix (only needed if the
%                    data is not in a data object)
%            
% Trains Gaussian Processes and returns the trained Gaussian processe
% object (alphas, along with the training error and
% loss). This is used by the predict function.
% Classification and Regression supported
%
% File:        @gaussprc/train.m
%
% Author:      Alexandros Karatzoglou
% Created:     22/12/2003
% Updated:     01/01/2004
%
% This code is released under the GNU Public License



if (nargin < 2) | (nargin > 3)
  error('wrong number of arguments');
else
  
if ~isa(gp, 'gaussprc')
  disp('This is no gaussian process object');
  return;
end;

if isa(d ,'data')
  x =  d.train.patterns; 
  y =  d.train.labels;
  m =  size(x,2);
else 
  x = d;
  m = size(x,2);
  % We take a column vector like the rest of svlab
  if( size(y, 1) == 1 )
    warning('gp train now takes a column vector for labels');
  end
end;

kernel = gp.kernel;

gp.x = x;
gp.y = y;

switch lower(gp.problem)
    
  case {'classification'}
    dpt = sv_dot(kernel, x);
    alpha = zeros(m,1);
    gradnorm = 1;
    while gradnorm > 0.001
      f = dpt * alpha;
      grad = -y ./ (1 + exp(y .* f));
      hess = exp(y .* f); 
      hess = hess ./ ((1 + hess).^2);
      alpha = alpha - (dpt * diag(hess) + eye(m))\(grad + alpha);
      gradnorm = norm(grad + alpha);
    end;
     gp.alpha = alpha;
     if(gp.error == true)
       y_train = sv_mult(gp.kernel,x,gp.alpha.*y);
       gp.error = (sum(y .* y_train < 0) / m);
     end
    
    
   case {'regression'}
     dpt = sv_dot(kernel, x);
     gp.alpha = (dpt + eye(m))\y;
     
     y_train = sv_mult(gp.kernel, x, gp.alpha);
     gp.error = sqrt(sum((y_train - y).^2)/m);
     
   otherwise
    disp('Unknown  problem type, supported types are : classification, regression');

end;


end;

