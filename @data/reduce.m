function [da]=reduce(da, train_size, test_size, val_size) ;
%

da.train_pat=da.train_pat(:, 1:train_size) ;
da.train_targ=da.train_targ(:, 1:train_size) ;

if nargin>2,
	da.test_pat=da.test_pat(:, 1:test_size) ;
	da.test_targ=da.test_targ(:, 1:test_size) ;
end ;

if nargin>3,
	da.val_pat=da.val_pat(:, 1:val_size) ;
	da.val_targ=da.val_targ(:, 1:val_size) ;
end ;
