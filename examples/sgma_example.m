clear all;

%set up dummy data
X = randn (10,100);

skew=10*eye(10);
skew2 = [skew,skew];
skew4=[skew2,skew2];
skew8=[skew4,skew4];
skew=[skew8,zeros(10,20)];

X=X+skew*10;
X=[X;randn(100,100)];

%set up variables
ker = vanilla_dot;
sgma_var = sgma;
sgma_var.blocksize=2;

[T,vecs,error_sequence,delta_sequence]=train(sgma_var,ker,X);

figure(1)

plot(delta_sequence)
 title('change in trace(Ktilde) vs iterations')
figure(2)
plot(error_sequence)
 title('trace(K)-trace(Ktilde) vs iterations')
