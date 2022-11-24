% Laplace propagation a.k.a Gaussian Process Chunking
% S V N Vishwanathan (vishy@axiom.anu.edu.au)

% Look at Smola, Vishwanathan and Eskin, NIPS 2003 paper for details 
% Search for svnvish: BUGBUG to check if anything needs to be tweaked

% Arguably not my best code but it works. What the heck :-)


addpath .. ../common

% svnvish: BUGBUG 
% Which dataset to use?
load ../data/adult2.mat

m = size( x.train, 1 );	% number of patterns
n = size( x.train, 2 );	% dimensionality

% svnvish: BUGBUG 
% Tweak the see for the random number generator
rand('state', 321454);

% svnvish: BUGBUG 
% check kernel parameters for various datasets
% See keerthi et al and platt's SMO paper for reference values 

kernel = rbf_dot;
kernel.sigma = 1/(0.5 * 10.0);

optimizer = intpoint_pr;

% svnvish: BUGBUG
% Parameters of Laplace propogation need to be tweaked here

% split dataset into NUM_BLOCKS blocks (arbitrary)
NUM_BLOCKS = 20;

% check value of C for  various datasets
BOUND_VALUE = 1.0;

% lets try 200 iterations (arbitrary)
NUM_ITERATIONS = 200;

% Tolerance for the low rank approximation
TOLERANCE = 1e-5;

% Minimum gap in objective function
MIN_GAP = 1e-5;

% end parameters of Laplace propogation


%%%%%%% Don't touch code below unless you know what you are doing %%%%%%%%

% initialize partition boundaries
partition = zeros( NUM_BLOCKS + 1, 1 );

partition( 1 ) = 0;
partition( NUM_BLOCKS + 1 ) = m;

for i = 1:(NUM_BLOCKS - 1)
  
  partition( i + 1 ) = partition( i ) + floor( m / NUM_BLOCKS );
  
end

% initialize values

alpha = zeros( size(y.train) );

master_alpha = alpha;

Objective = 0;

fprintf( 1, 'Itr \t Obj \t \t Gap \n \n' );

for Iterations = 1:NUM_ITERATIONS
  
  % Randomly permute the training dataset
  
  index = randperm( m );
  
  x.train = x.train( index, :);
  y.train = y.train( index );
  
  %master_alpha = alpha;
  
  master_alpha = alpha( index );
  
  % not really necessary. Just for safety ...
  alpha = zeros( size( y.train ) );
  
  for j = 1:NUM_BLOCKS
    
    this_chunk = zeros( size( y.train ) );
    the_rest = ones( size( y.train ) );
    
    
    this_chunk( partition( j ) + 1 : partition( j + 1 ) ) = 1;
    the_rest( partition( j ) + 1 : partition( j + 1 ) ) = 0;
    
    this_chunk = find( this_chunk );
    the_rest = find( the_rest );
    
    % prepare variables for passing to the optimizer
    H = sv_pol( kernel, x.train(this_chunk, :)', y.train( this_chunk ) );
    
    Z = chol_reduce( H, TOLERANCE );
    
    Hfw = sv_pol( kernel, x.train( the_rest, : )', x.train( this_chunk, : )', ...
		  y.train( the_rest), y.train( this_chunk ) );
    
    c = ( master_alpha( the_rest )' * Hfw - ones( size( this_chunk )  )')';
    
    A = y.train( this_chunk )';
    
    b = - y.train( the_rest )' * master_alpha( the_rest );
    
    l = zeros( size( this_chunk ) );
    
    u = BOUND_VALUE * ones( size( this_chunk ) ) ;
    
    [ alpha( this_chunk ), Beta, how ] = ...
	optimize_smw( optimizer, c, Z, eye( size( Z, 2 ) ), A, b, ...
		      l, u ); 

    if( strcmp( how, 'converged') == 0 ) 
      fprintf(1, '%s\n', how);
    
    end
    
    % svnvish: BUGBUG
    % Comment this if you want to simulate parallel LP
    master_alpha( this_chunk ) = alpha( this_chunk ); 
    
  end
  
  OldObjective = Objective;
  
  Objective = sum( alpha ) - 0.5 * alpha' * sv_pol( kernel, x.train', y.train ) ...
      * alpha; 
  
  % Sanity check code begin
  if( Objective + MIN_GAP < OldObjective )
    
    Objective 
    OldObjective
    
    disp('Objective is decreasing!');
    %break;
    
  end
  
  % Sanity check code end
  
  fx = ( sv_mult( kernel, x.train', x.train', (alpha .*y.train )) - Beta ) .* y.train;
  
  gap = alpha'* max( fx - 1, 0 ) + ... 
	( BOUND_VALUE - alpha )'*max( 1 - fx, 0 );
  
  gap = gap/( Objective + gap );

  fprintf( 1, '%d \t %4.4f \t %2.6f \n', Iterations, Objective, gap );
  
  if( gap < MIN_GAP )
    
    % Report results here
    fprintf( 1, '\n\n\n' );
    fprintf( 1, 'No. of Iterations : %d \n', Iterations );
    fprintf( 1, 'No. of Chunks     : %d \n', NUM_BLOCKS );
    fprintf( 1, 'Value of C        : %f \n', BOUND_VALUE );
    fprintf( 1, 'Objective         : %f \n', Objective );
    fprintf( 1, 'Gap               : %f \n', gap );
    display( kernel );
    
    break;
    
  end
  
end