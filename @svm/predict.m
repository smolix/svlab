function y = predict(sv,x)
% sv = predict(svm,x)
% Predict returns the predicted values of y using data x
% and a trained support vector object
%
%for additional documentation see 
%   
%   

% File:        @svm/train.m
%
% Author:      Alexandros A. Karatzoglou
% Created:     12/11/2002
% Updated:     
%
% This code is released under the GNU Public License

if (nargin ~= 2) 
  error('wrong number of arguments');
else
  
  
  if isa(x ,'data')
    x =  x.train.patterns; 
  end;
   
   if ~isa(sv, 'svm')
     disp('This is no support vector object');
     return;
   end;
   
   if size(sv.alpha) == 0
     disp('This seems to be an un-trained support vector object') ;
     return;
   end;
   
  switch lower(sv.type)
    
   case{'c-svc'}
  
    y =  (sv_mult(sv.kernel,x,sv.x,sv.alpha.*sv.y) + sv.beta);
    
   case{'nu-svc'}
    
    y =  (sv_mult(sv.kernel,x,sv.x, sv.alpha.*sv.y) + sv.beta);
   
   case{'semi-sv'}

    Phi_test = [sin(x); cos(x); ones(1,length(x))];
    y = sv_mult(sv.kernel, x, sv.x, sv.alpha) + Phi_test' * sv.beta;

    
   case{'epsilon-svr'}
    
    y = (sv_mult(sv.kernel, x, sv.x, - sv.alpha(1:size(sv.x,2)) + sv.alpha(size(sv.x,2)+1:2*size(sv.x,2))) + sv.beta);
     
   case{'nu-svr'}

    y = (sv_mult(sv.kernel, x, sv.x, - sv.alpha(1:size(sv.x,2)) + sv.alpha(size(sv.x,2)+1:2*size(sv.x,2))) + sv.beta);
    
    
    case{'one-class'}
     
     y = (sv_mult(sv.kernel,x,sv.x,sv.alpha) - sv.beta);
  
   otherwise
      disp('Unknown SVM type, supported types are : c-svc, nu-scv, eps-svr, nu-svr, one-class');
      
  end;

  
end;

