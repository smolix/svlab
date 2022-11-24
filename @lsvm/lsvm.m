function d = lsvm(varargin)
% Constructor for the lsvm class 
%
% D = lsvm(TYPE, PROBLEMTYPE, C, Nu, Epsilon)  
% 
% constructs an object containing all information necessary for a svm
% object. 
%
%varlist = {'type', 'problem', 'c', 'nu', 'Eps'};
%
% KERNEL    = dot product to use {rbf_dot, poly_dot, bessel_dot, tanh_dot}
% PROBLEMTYPE = {classification} 
% nu            nu parameter
% itmax         maximum number of iteraations
% 
%
% File:        @lsvm/lsvm.m
%
% Author:      Alexandros Karatzoglou
% Created:     04/7/04
% Updated:     04/7/04
% 


varlist = {'kernel', 'problemtype', 'nu','lambda','tol','itmax'};
	   


emptystring = '';
defaults = {rbf_dot, 'classification', 0.1, 0.3, 0.0001, 400};



d = cell2struct(defaults, varlist, 2);
d = read_param(varargin, d,varlist,defaults);


d.w = [];
d.iter = [];
d.gamma = [];
d.opt = [];
d.pivots = [];
d.error = true;
                                        % training error 
d.loss = [];				% training loss

d.x = [];



d = class(d, 'lsvm');

