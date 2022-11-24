function y = predict(l,x)
% sv = predict(svm,x)
% Predict returns the predicted values of y using data x
% and a trained lagrangian support vector object
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

   if ~isa(l, 'lsvm')
     disp('This is no support vector object');
     return;
   end;

   if size(l.w) == 0
     disp('This seems to be an un-trained lagrangian support vector object') ;
     return;
   end;



    y =  sv_mult(l.kernel,x,l.x,l.w);
end