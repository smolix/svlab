function phi = predict(d, kernel, x)
%PREDICT Predict the class of a pattern
%       based on learning from an online machine.
%
%	PHI = Predict(D, KERNEL, X) shows the pattern X to the
%	online machine using the trained online_pr object D the kernel
%       KERNEL (must be the same kernel and hyperparameters used by the train function) and 
%       and gets the PHI value i.e. a class label (sign(PHI)).
%
% File:        @online_pr/predict.m
%
% Author:      Alexandros Karatzoglou
% Created:     16/07/04
% Updated:     16/07/04
%
% This code is released under the GNU Public License
% Copyright by The Australian National University



 buffer_is_not_full = ((d.online_start == 1) & ...
			(d.online_stop < d.bufsize));

 if (buffer_is_not_full)
   phi = sv_mult(kernel, x, d.online_data(:,1:d.online_stop), ...
		 d.online_alpha(1:d.online_stop)) + d.online_b;
 else
   phi = sv_mult(kernel, x, d.online_data, d.online_alpha) + ...
       d.online_b;
 end
 