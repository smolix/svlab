function y = predict(gp,x)
% gp = predict(gp,x)
% Predict returns the predicted values of y using data x
% and a trained gaussian process object
%
%for additional documentation see 
%   
%   

% File:        @gaussprc/predict.m
%
% Author:      Alexandros A. Karatzoglou
% Created:     12/8/2004
% Updated:     
%
% This code is released under the GNU Public License

if (nargin ~= 2) 
  error('wrong number of arguments');
else
  
  
  if isa(x ,'data')
    x =  x.train.patterns; 
  end;
   
   if ~isa(gp, 'gaussprc')
     disp('This is no gaussian process object');
     return;
   end;
   
   if size(gp.alpha) == 0
     disp('This seems to be an un-trained gaussian process object') ;
     return;
   end;
   
  
    y =  sv_mult(gp.kernel,x,gp.x,gp.alpha);
    

  
end;

