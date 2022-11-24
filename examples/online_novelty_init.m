addpath .. ../common

global SVLAB_ONLINE_ALPHA
global SVLAB_ONLINE_DATA
global SVLAB_ONLINE_KAPPA
global SVLAB_ONLINE_RHO
global SVLAB_ONLINE_START
global SVLAB_ONLINE_STOP

% requires usps data
load ../../usps/usps.mat

% tracks iterations over all training runs for lambda
global iterations
iterations = 0;

m = size(train_patterns,2);	% number of patterns
n = size(train_patterns,1);	% dimensionality

nov = online_novelty;
init_buffer(nov, n);
