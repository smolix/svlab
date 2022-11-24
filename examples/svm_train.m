% Example file for SVM training
% S V N Vishwanathan (vishy@axiom.anu.edu.au)

addpath .. ../common

% load data
load ../data/breast.mat

% value of C
BOUND_VALUE = 1.0;

% Minimum gap in objective function
MIN_GAP = 1e-5;

% Create a SVM object and set parameters
sv = svm;

sv.kernel = rbf_dot;  % kernel type 
sv.type = 'c-svc';    % problem type
sv.problem = 'twoclass';
sv.c = BOUND_VALUE * size(x.train, 2); % C value

% set the kernel parameters, see keerthi et al for reference values
sv.kernel.sigma = 1/(2 * 4.0);

% Train the support vector machine
sv = train( sv, x.train, y.train );

Objective = sum( sv.alpha ) - ...
    0.5 * sv.alpha' * sv_pol( sv.kernel, x.train, y.train ) * sv.alpha

% perform prediction
fx = predict( sv, x.train )'.*y.train;

% Now compute gap
lowergap = sv.alpha'* max( fx - 1, 0 );
uppergap = ( BOUND_VALUE - sv.alpha )' * max( 1 - fx, 0 );
gap = lowergap + uppergap;

gap = gap/( Objective + gap )

if( gap < MIN_GAP )
  
  % Report results if required here
  
  fprintf( 1, 'Converged properly! \n');
  
else

  fprintf( 1, 'Did not converge! \n');
  
end

