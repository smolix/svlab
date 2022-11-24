function [alpha, beta, error] = optimize(d, kernel, x, y)

% optimize implements the Sequential Minimal Optimization 
% solving the optimization problem stemming from
% support vector pattern recognition problems following a
% method proposed by j. platt.
% It cycles through the training set and trains on those
% patterns that will profit most from training - decrease
% of the complete target function is guaranteed
%
% d is the pr_smo object 
% kernel the kernel object to be used 
% x the input patterns 
% y the binary target values
%
% File:        @re_smo/optimize.m
%
% Author:      Alexandros Karatzoglou, Alex Smola
% Created:     07/22/98
% Updated:     25/02/04     
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initializations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global re_dot re_traindata re_targettrain re_regularization
global re_b re_alpha re_salpha re_error re_dptdiagonal re_epsilon re_samples re_tol
global Counter SaveCounter re_filename
global PrimalObj DualObj SigFig Ver

Counter = 0;
SaveCounter = d.counter;			% save every d.counter steps
Ver = d.verbose;
re_dot = kernel;
re_samples = length(y);
re_traindata = x;
re_filename = d.filename;
re_targettrain = reshape(y, re_samples, 1);

if(length(d.C) == 1)
  re_regularization =  repmat(d.C,re_samples,1);
else 
  re_regularization = d.C;
end;

re_epsilon = d.epsilon;
re_tol = d.tol;
re_numchanged = d.numchanged;
re_examineall = d.examineall;		

Restart = fexist(re_filename);		% reload where we started from
PrimalObj = 0;
DualObj = -Inf;
SigFig = 0;

if Restart
  fprintf('loading data from disk ... ');
  load(re_filename);
  fprintf('done\n');
  re_examineall = 0;
else
  re_dptdiagonal = zeros(re_samples,1);
  for i=1:re_samples
    re_dptdiagonal(i) = sv_dot(re_dot,re_traindata(:,i));
  end;
  re_alpha = zeros(re_samples,1);
  re_salpha = zeros(re_samples,1);
  re_error = - re_targettrain;
  re_b = 0;
end;

MainLoopCounter = 0;

% main loop
if (d.verbose ~= 0 )
  fprintf('entering the main loop\n');
end;
while ((re_numchanged > 0 | re_examineall | Counter == 0) & (SigFig < 3))
  MainLoopCounter = MainLoopCounter + 1;
  re_numchanged = 0;
  mask = 1:re_samples;
  if (re_examineall == 0)
    inner_mask = (re_alpha > 0) & (re_alpha < re_regularization);
    mask = mask(inner_mask);
  end;
  mask = RandSwap(mask);
  for i=mask
    re_numchanged = re_numchanged + ExamineExample(i);
  end;
  if mod(MainLoopCounter, 2) == 0
    MinimumNumChanged = max(1, (SigFig < 2) * re_samples * 0.1);
  else
    MinimumNumChanged = 1;
  end;
  if (re_examineall)
    re_examineall = 0;
  elseif (re_numchanged < MinimumNumChanged)
    re_examineall = 1;
    if (d.verbose ~= 0)
    fprintf('Examining the complete dataset\n');
    end;
  end;
  Instrumentation;
 % SaveData;
end;

alpha = re_alpha;
beta = re_b;
error = re_error;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ExamineExample (loops over all examples and tries to get them right)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function examineexample = ExamineExample(i2)

global re_dot re_traindata re_targettrain re_regularization
global re_b re_alpha re_error re_dptdiagonal re_samples re_epsilon re_tol
global Counter SaveCounter re_filename

y2 = re_targettrain(i2);
alpha2 = re_alpha(i2);
salpha2 = re_salpha(i2)
e2 = re_error(i2);
r2 = e2 - re_eps;

examineexample = 0;

if ((( r2 < - re_tol) & (alpha2 < re_regularization(i2))) | ((r2 > re_tol) & (alpha2 > 0)))
  InTheInterval = (re_alpha > 0) & (re_alpha < re_regularization);
  if sum(InTheInterval)
    if (e2 > 0)
      [dummy, i1] = min(re_error);
    else
      [dummy, i1] = max(re_error);
    end;
    if TakeStep(i1, i2)
      examineexample = 1;
      return;
    end;
  end;
  mask = 1:re_samples;
  mask = RandSwap(mask(InTheInterval));
  for i1=mask
    if TakeStep(i1, i2)
      examineexample = 1;
      return;
    end;
  end;
  mask = 1:re_samples;
  mask = RandSwap(mask(not(InTheInterval)));
  for i1=mask
    if TakeStep(i1, i2)
      examineexample = 1;
      return;
    end;
  end;
end;
return;
  

function takestep = TakeStep(i1, i2)	% i1, i2 are the indices

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TakeStep (takes step towards bigger objective function)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global re_dot re_traindata re_targettrain re_regularization
global re_b re_alpha re_error re_dptdiagonal re_epsilon re_tol re_samples
global Counter SaveCounter re_filename

if (i1 == i2)
  takestep = 0;
  return;
end;

alpha1 = re_alpha(i1);
alpha2 = re_alpha(i2);
salpha1 = re_salpha(i1);
salpha2 = re_salpha(i2);
y1 = re_targettrain(i1);
y2 = re_targettrain(i2);
e1 = re_error(i1);
e2 = re_error(i2);
k11 = re_dptdiagonal(i1);
k22 = re_dptdiagonal(i2);

gamma = (alpha1 - salpha1) + (alpha2 - salpha2);
L = max(gamma - re_regularization(i2), re_regularization(i1));
H = min(gamma + re_regularization(i2), re_regularization(i1));

if (L == H) 
  takestep = 0;
  return;
end;

l=min(gamma,0);
h = max(gamma,0);

k12 = sv_dot(re_dot,re_traindata(:,i1),re_traindata(:,i2));

eta = 2*k12 - k11 - k22;
if (eta < 0)
  b0 = (alpha1 - salpha1) - (e1 - e2)/eta;
  bp = b0 + 2*re_eps/eta ;
  bm = b0 - 2*re_eps/eta;
  beta = max(min(b0, -eta),l);
else if ((e1 - e2) < 0)
    beta = h ;
    if ((e1 - e2 +2 * re_eps) < 0 )
      beta = H;
    end;
else
  beta = l;
  if((e1 - e2 - 2* re_eps) >0 )
    beta = L;
  end;
end;

  
  
if abs(beta - (alpha1 - salpha1)) < re_eps*(re_eps + alpha1 + abs(beta) + salpha1);
  takestep = 0;
  return;
end;



b1 = re_error(i1) + y1*(a1 - alpha1)*k11 + y2*(a2 - alpha2)*k12 + re_b;
if (a1 > 0) & (a1 < re_regularization(i1))
  b = b1;
else
  b2 = re_error(i2) + y1*(a1 - alpha1)*k12 + y2*(a2 - alpha2)*k22 + re_b;
  if (a2 > 0) & (a2 < re_regularization(i2))
    b = b2;
  else
    b = (b1 + b2)/2;			
  end;
end;

Counter = Counter + 1;			% increase evaluation counter
re_error = re_error - b + re_b + ...
    sv_mult(re_dot,re_traindata,re_traindata(:,[i1, i2]), ...
    [ (a1 - alpha1) - (sa1 - salpha1), (a2 - alpha2) - (sa2 - salpha2)]');

re_alpha(i1) = alpha1;
re_alpha(i2) = alpha2;
re_salpha(i1) = salpha1;
re_salpha(i2) = salpha2;
re_b = beta;
takestep = 1;

% save data to disk

if mod(Counter, SaveCounter) == 0
  SaveData;
end;

% compute primal and dual objective function

if mod(Counter, 100) == 0
  Instrumentation;
%  CheckStop;
end;

return;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RandSwap: randomly swaps vector y (tested)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function x = RandSwap(y)

length_y = length(y);
position = floor(rand * length_y);
x = [y((position+1):length_y) y(1:position)];
return;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CheckStop: checks whether it is better to stop or not
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function CheckStop

if fexist('/var/tmp/matlab.smola.stop')
  fprintf('Stopping Process - somebody created /var/tmp/matlab.smola.stop\n');
  while fexist('/var/tmp/matlab.smola.stop'),
    pause(30);
  end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Instrumentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Instrumentation

global re_dot re_traindata re_targettrain re_regularization
global re_b re_alpha re_error re_dptdiagonal re_epsilon re_tol re_samples
global Counter SaveCounter re_filename

global PrimalObj DualObj SigFig Ver

% compute primal and dual objective function

AlphaDptAlpha = (re_error + re_b + re_targettrain)' * ...
    (re_alpha .* re_targettrain); 
PrimalObj = -sum(re_alpha) + 0.5 * AlphaDptAlpha;

ReducedStabilities = re_targettrain .* re_error; 
KKT = re_alpha' * max(0, ReducedStabilities) - ...
    (re_regularization - re_alpha)' * min(0, ReducedStabilities);

if (PrimalObj - KKT > DualObj)
  DualObj = PrimalObj - KKT;		% compute feasibility gap
end;
SigFig = log10((abs(PrimalObj)+1)/abs(PrimalObj - DualObj));

if (Ver ~=0)
  fprintf('[%f]\t[%f]\t[%f]\t[%f]\n', PrimalObj, KKT, DualObj, SigFig);
end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SaveData
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function SaveData

global re_b re_alpha re_error re_dptdiagonal re_epsilon re_tol re_samples
global re_filename

fprintf('saving data ');
save(re_filename, 're_dptdiagonal', 're_alpha', 're_error', 're_b');
fprintf('... done\n');

