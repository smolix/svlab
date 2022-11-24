function sv = train(sv,d,y)
% sv = train(svm,d,x,y)
% Example code for training Support Vector Machines.
% 
% SV = TRAIN(SV,D,Y) returns a trained Support Vector Object (alphas and beta) 
%                    SV is a support vector object,
%                    D is a data object or the patterns matrix
%                    Y is the labels matrix (only needed if the
%                    data is not in a data object)
%            
% Trains a support vector machine (sv) and returns the trained support
% vector object (alphas & beta, along with the training error and
% loss). This can be used by the predict function.
% Types of Support Vector Machines :
%
% c-svc  : c soft margin binary classifier
% nu-svc : nu soft margin binary classifier
% c-svr  : c suport vector regression
% nu-svr : nu support vector regression
% 
%
% File:        @svm/train.m
%
% Author:      Alexandros Karatzoglou
% Created:     12/11/2002
% Updated:     
%
% This code is released under the GNU Public License



if (nargin < 2) | (nargin > 3)
  error('wrong number of arguments');
else
  
if ~isa(sv, 'svm')
  disp('This is no support vector object');
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
    warning('svm train now takes a column vector for labels');
  end
end;

switch lower(sv.type)
    
 case {'c-svc'}
  
  
  H = sv_pol(sv.kernel,x,y);
  c = -ones(m,1);
  A = y';
  b = 0;
  l = zeros(m,1);
  u = repmat((sv.c/m),m,1);
  optimizer = intpoint_pr;
  [sv.alpha, b_pred] = optimize(optimizer, c,H,A,b,l,u);
  sv.y = y;
  sv.x = x;
  sv.beta = - b_pred(1);
  
      y_train = sv_mult(sv.kernel,x,sv.alpha.*y) - b_pred(1);
      sv.error = (sum(y .* y_train < 0) / m);
      sv.loss =  sum(max(1 - y .* y_train, 0))/m;

    

   case {'nu-svc'}



    H = sv_pol(sv.kernel,x,y);
    c = zeros(m,1);
    A = sparse([y';ones(1,m)]);
    b = [0 ;(sv.nu*m)];
    l = zeros(m,1);
    u = repmat(1,m,1);
    optimizer = intpoint_pr;
    [sv.alpha, b_pred] = optimize(optimizer, c,H,A,b,l,u);
    sv.beta = - b_pred(1);
    sv.y = y;
    sv.x = x;

      y_train = sv_mult(sv.kernel,x,sv.alpha.*y) - b_pred(1);
      sv.error = (sum(y .* y_train < 0) / m);
      sv.loss =  sum(max(1 - y .* y_train, 0))/m;

    
   case{'semi-svr'}
     
    H1 = sv_dot(dot, x);
    H2 = zeros(m,1);
    c = [y+ sv.epsilon ; -y + sv.epsilon];
    Phi = [sin(x); cos(x); ones(1,N)];
    A = [Phi, -Phi];
    b = [0, 0, 0];
    l = zeros(2*m,1);
    u = C * ones(1,2*N);
    [sv.alpha, sv.beta, how] = optimize(reopt, h1, h2, c', A', b, l, u);

%    Alpha = - alpha(1:N) + alpha((N+1):(2*N));
 %   w2_semi = Alpha' * h1 * Alpha;

    Phi_test = [sin(x_test); cos(x_test); ones(1,length(x_test))];
  %  y_est = sv_mult(dot, x_test, x, Alpha) + Phi_test' * sv.beta;

  
      
   case {'epsilon-svr'}
    

    H1 = sv_dot(sv.kernel,x);
    H2 = zeros(m,1);
    c = [y + sv.epsilon ; - y + sv.epsilon];
    A = [ones(1,m), -ones(1,m)];
    l = zeros(2*m,1);
    u = repmat(sv.c/m,2*m,1);
    b = 0;
    optimizer = intpoint_re;
    [sv.alpha, sv.beta]= optimize(optimizer, c, H1, H2, A, b, l, u);
    sv.x = x;
    
    if (sv.error == true)
      y_train = (sv_mult(sv.kernel, x, - sv.alpha(1:size(sv.x,2))+sv.alpha(size(sv.x,2)+1:2*size(sv.x,2))) + sv.beta);
      sv.error = sqrt(sum((y_train - y).^2)/m);
      l1_err = sum(abs(y_train - y))/m;
      sv.loss = sum(max(abs(y_train - y) - sv.epsilon, 0))/m;
    end
   
   case {'nu-svr'}
    

    H1 = sv_dot(sv.kernel,x);
    H2 = zeros(m,1);
    c = [y  ; - y ];
    A = [ones(1,m), -ones(1,m);ones(1,2*m)];
    b = [0 ; sv.nu*m];
    l = zeros(2*m,1);
    u = repmat(1,2*m,1);
    optimizer = intpoint_re;
    [alpha, b_pred]= optimize(optimizer, c, H1, H2, A, b, l, u);
     sv.x = x;
    if (sv.error == true)
      y_train = (sv_mult(sv.kernel, x, - sv.alpha(1:size(sv.x,2))+sv.alpha(size(sv.x,2)+1:2*size(sv.x,2))) + sv.beta);
      sv.error = sqrt(sum((y_train - y).^2)/m);
      l1_err = sum(abs(y_train - y))/m;
      sv.loss = sum(max(abs(y_train - y) - sv.epsilon, 0))/m;
    end

   
   case{'one-class'}
    
    H = sv_dot(sv.kernel,x);
    c = zeros(m,1);
    A = ones(1,m);
    b = 1;
    l = zeros(m,1);
    u = repmat(1/(sv.nu*m),m,1);
    optimizer = intpoint_pr; 
    sv.alpha = optimize(optimizer, c,H,A,b,l,u); 
    i = 1;
    sv.x = x;
    while(sv.alpha(i)<=10^-5 | sv.alpha(i)>=1/(sv.nu*m))
      i = i +1;
    end;
    sv.beta =  sv_mult(sv.kernel,x(:,i),x,sv.alpha);   
    y_train = (sv_mult(sv.kernel,x,sv.alpha) - sv.beta);
    sv.error = (sum(y_train < 0) / m);
    sv.loss =  sum(max(1 - y_train, 0))/m;
    
   otherwise
    disp('Unknown SVM type, supported types are : one-class c-svc, nu-scv, eps-svr, nu-svr');

end;







end;
sv = sv;
