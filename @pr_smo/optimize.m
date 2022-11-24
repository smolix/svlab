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
% File:        @pr_smo/optimize.m
%
% Author:      Alex J. Smola, Alexandros Karatzoglou
% Created:     07/22/98
% Updated:     25/02/04     
%






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initializations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global Pr_Dot Pr_PatternsTrain Pr_PolaritiesTrain Pr_Regularization
global Pr_B Pr_Alpha Pr_Error Pr_DptDiagonal Pr_Epsilon Pr_Samples Pr_Tol
global Counter SaveCounter Pr_Filename
global PrimalObj DualObj SigFig Ver

Counter = 0;
SaveCounter = d.counter;			% save every d.counter steps
Ver = d.verbose;
Pr_Dot = kernel;
Pr_Samples = length(y);
Pr_PatternsTrain = x;
Pr_Filename = d.filename;
Pr_PolaritiesTrain = reshape(y, Pr_Samples, 1);

if(length(d.C) == 1)
  Pr_Regularization =  repmat(d.C,Pr_Samples,1);
else 
  Pr_Regularization = d.C;
end;

Pr_Epsilon = d.epsilon;
Pr_Tol = d.tol;
Pr_NumChanged = d.numchanged;
Pr_ExamineAll = d.examineall;		

Restart = fexist(Pr_Filename);		% reload where we started from
PrimalObj = 0;
DualObj = -Inf;
SigFig = 0;

if Restart
  fprintf('loading data from disk ... ');
  load(Pr_Filename);
  fprintf('done\n');
  Pr_ExamineAll = 0;
else
  Pr_DptDiagonal = zeros(Pr_Samples,1);
  for i=1:Pr_Samples
    Pr_DptDiagonal(i) = sv_dot(Pr_Dot, Pr_PatternsTrain(:,i));
  end;
  Pr_Alpha = zeros(Pr_Samples,1);
  Pr_Error = -Pr_PolaritiesTrain;
  Pr_B = 0;
end;

MainLoopCounter = 0;

% main loop
if (d.verbose ~= 0 )
  fprintf('entering the main loop\n');
end;
while ((Pr_NumChanged > 0 | Pr_ExamineAll | Counter == 0) & (SigFig < 3))
  MainLoopCounter = MainLoopCounter + 1;
  Pr_NumChanged = 0;
  mask = 1:Pr_Samples;
  if (Pr_ExamineAll == 0)
    inner_mask = (Pr_Alpha > 0) & (Pr_Alpha < Pr_Regularization);
    mask = mask(inner_mask);
  end;
  mask = RandSwap(mask);
  for i=mask
    Pr_NumChanged = Pr_NumChanged + ExamineExample(i);
  end;
  if mod(MainLoopCounter, 2) == 0
    MinimumNumChanged = max(1, (SigFig < 2) * Pr_Samples * 0.1);
  else
    MinimumNumChanged = 1;
  end;
  if (Pr_ExamineAll)
    Pr_ExamineAll = 0;
  elseif (Pr_NumChanged < MinimumNumChanged)
    Pr_ExamineAll = 1;
    if (d.verbose ~= 0)
    fprintf('Examining the complete dataset\n');
    end;
  end;
  Instrumentation;
 % SaveData;
end;

alpha = Pr_Alpha;
beta = Pr_B;
error = Pr_Error;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ExamineExample (loops over all examples and tries to get them right)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function examineexample = ExamineExample(i2)

global Pr_Dot Pr_PatternsTrain Pr_PolaritiesTrain Pr_Regularization
global Pr_B Pr_Alpha Pr_Error Pr_DptDiagonal Pr_Samples Pr_Epsilon Pr_Tol
global Counter SaveCounter Pr_Filename

y2 = Pr_PolaritiesTrain(i2);
alpha2 = Pr_Alpha(i2);
e2 = Pr_Error(i2);
r2 = e2 * y2;

examineexample = 0;

if (((r2 < -Pr_Tol) & (alpha2 < Pr_Regularization(i2))) | ...
      ((r2 > Pr_Tol) & (alpha2 > 0)))
  InTheInterval = (Pr_Alpha > 0) & (Pr_Alpha < Pr_Regularization);
  if sum(InTheInterval)
    if (e2 > 0)
      [dummy, i1] = min(Pr_Error);
    else
      [dummy, i1] = max(Pr_Error);
    end;
    if TakeStep(i1, i2)
      examineexample = 1;
      return;
    end;
  end;
  mask = 1:Pr_Samples;
  mask = RandSwap(mask(InTheInterval));
  for i1=mask
    if TakeStep(i1, i2)
      examineexample = 1;
      return;
    end;
  end;
  mask = 1:Pr_Samples;
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

global Pr_Dot Pr_PatternsTrain Pr_PolaritiesTrain Pr_Regularization
global Pr_B Pr_Alpha Pr_Error Pr_DptDiagonal Pr_Epsilon Pr_Tol Pr_Samples
global Counter SaveCounter Pr_Filename

if (i1 == i2)
  takestep = 0;
  return;
end;

alpha1 = Pr_Alpha(i1);
alpha2 = Pr_Alpha(i2);
y1 = Pr_PolaritiesTrain(i1);
y2 = Pr_PolaritiesTrain(i2);
e1 = Pr_Error(i1);
e2 = Pr_Error(i2);
k11 = Pr_DptDiagonal(i1);
k22 = Pr_DptDiagonal(i2);

s = y1 * y2;
if (s < 0)				
  L = max(0, alpha2 - alpha1);
  H = min(Pr_Regularization(i2), Pr_Regularization(i1) + alpha2 - alpha1);
else
  L = max(0, alpha1 + alpha2 - Pr_Regularization(i1));
  H = min(Pr_Regularization(i2), alpha1 + alpha2);
end;

k12 = sv_dot(Pr_Dot, Pr_PatternsTrain(:,i1), Pr_PatternsTrain(:,i2));

eta = 2*k12 - k11 - k22;
if (eta < 0)
  a2 = alpha2 - y2*(e1 - e2)/eta;
  a2 = max(a2, L);
  a2 = min(a2, H);
  a1 = alpha1 + s*(alpha2 - a2);
else
  % note: we compute v1*y1 and v2*y2 instead !!!
  v1 = y1 * (Pr_Error(i1) + Pr_B) - alpha1*k11 - s * alpha2 * k12;
  v2 = y2 * (Pr_Error(i2) + Pr_B) - s * alpha1 * k12 - alpha2*k22;
  
  a1_L = alpha1 + s*(alpha2 - L);
  a1_H = alpha1 + s*(alpha2 - H);
  
  % this is only true up to a constant but we don't care about that
  Lobj = -v1*a1_L - 0.5*k11*(a1_L^2) - v2*L - 0.5*k22*(L^2) - s*k12*a1_L*L;
  Hobj = -v1*a1_H - 0.5*k11*(a1_H^2) - v2*H - 0.5*k22*(H^2) - s*k12*a1_H*H;

  % check if something really changed
  if (Lobj > Hobj + Pr_Epsilon)	
    a2 = L;
    a1 = a1_L;
  else
    a2 = H;
    a1 = a1_H;
  end;
end;

if abs(a2 - alpha2) < Pr_Epsilon*(a2+alpha2+Pr_Epsilon);
  takestep = 0;
  return;
end;

b1 = Pr_Error(i1) + y1*(a1 - alpha1)*k11 + y2*(a2 - alpha2)*k12 + Pr_B;
if (a1 > 0) & (a1 < Pr_Regularization(i1))
  b = b1;
else
  b2 = Pr_Error(i2) + y1*(a1 - alpha1)*k12 + y2*(a2 - alpha2)*k22 + Pr_B;
  if (a2 > 0) & (a2 < Pr_Regularization(i2))
    b = b2;
  else
    b = (b1 + b2)/2;			
  end;
end;

Counter = Counter + 1;			% increase evaluation counter
Pr_Error = Pr_Error - b + Pr_B + ...
    sv_mult(Pr_Dot, Pr_PatternsTrain, Pr_PatternsTrain(:,[i1, i2]), ...
    [y1 * (a1 - alpha1), y2 * (a2 - alpha2)]');

Pr_Alpha(i1) = a1;
Pr_Alpha(i2) = a2;
Pr_B = b;
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

global Pr_Dot Pr_PatternsTrain Pr_PolaritiesTrain Pr_Regularization
global Pr_B Pr_Alpha Pr_Error Pr_DptDiagonal Pr_Epsilon Pr_Tol Pr_Samples
global Counter SaveCounter Pr_Filename

global PrimalObj DualObj SigFig Ver

% compute primal and dual objective function

AlphaDptAlpha = (Pr_Error + Pr_B + Pr_PolaritiesTrain)' * ...
    (Pr_Alpha .* Pr_PolaritiesTrain); 
PrimalObj = -sum(Pr_Alpha) + 0.5 * AlphaDptAlpha;

ReducedStabilities = Pr_PolaritiesTrain .* Pr_Error; 
KKT = Pr_Alpha' * max(0, ReducedStabilities) - ...
    (Pr_Regularization - Pr_Alpha)' * min(0, ReducedStabilities);

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

global Pr_B Pr_Alpha Pr_Error Pr_DptDiagonal Pr_Epsilon Pr_Tol Pr_Samples
global Pr_Filename

fprintf('saving data ');
save(Pr_Filename, 'Pr_DptDiagonal', 'Pr_Alpha', 'Pr_Error', 'Pr_B');
fprintf('... done\n');

