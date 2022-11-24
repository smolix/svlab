function d = svm(varargin)
% Constructor for the svm class 
%
% D = svm(TYPE, PROBLEMTYPE, C, Nu, Epsilon)  
% 
% constructs an object containing all information necessary for a svm
% object. 
%
%varlist = {'type', 'problem', 'c', 'nu', 'Eps'};
%
% KERNEL    = dot product to use {rbf_dot, poly_dot, bessel_dot, tanh_dot}
% TYPE      = SVM types : c-svc n-svc, epsilon-svr n-svr, one-class 
% PROBLEMTYPE = {oneclass, twoclass, multiclass, regression} 
% C             C parameter
% nu            nu parameter
% Eps           epsilon regression parameter
%
% File:        @svm/svm.m
%
% Author:      Alexandros Karatzoglou
% Created:     04/12/02
% Updated:     04/12/02
% 


varlist = {'kernel', 'type','problem', 'c', 'nu', 'epsilon'};
	   


emptystring = '';
defaults = {rbf_dot, 'c-svc', 'twoclass', 1, 1, 1};





d = cell2struct(defaults, varlist, 2);
d = read_param(varargin, d,varlist,defaults);


d.alpha = [];
d.beta = [];


d.error = true;
                                        % training error 
d.loss = [];				% training loss

d.y = [];

d.x = [];



d = class(d, 'svm');

