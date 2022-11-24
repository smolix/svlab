function d = gaussprc(varargin)
% Constructor for the gaussian processes class 
%
% D = gassprc(KERNEL, PROBLEMTYPE)  
%
% 
% constructs an object containing all information necessary for a svm
% object. 
%
%varlist = {'kernel', 'problem'}
%
% KERNEL    = dot product to use {rbf_dot, poly_dot, bessel_dot, tanh_dot}
% PROBLEMTYPE = {classification  regression} 
%
% File:        @gaussprc/gaussprc.m
%
% Author:      Alexandros Karatzoglou
% Created:     20/12/03
% Updated:     01/01/04
% 


varlist = {'kernel', 'problem'};
	   


emptystring = '';
defaults = {rbf_dot, 'classification'};





d = cell2struct(defaults, varlist, 2);
d = read_param(varargin, d,varlist,defaults);


d.alpha = [];

d.error = true;
                                        % training error 
d.loss = [];				% training loss

d.y = [];

d.x = [];



d = class(d, 'gaussprc');

