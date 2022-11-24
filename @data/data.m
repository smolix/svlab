function d=data(varargin)
% Constructor for the data class 
% D = DATA(FORMAT, PROBLEMTYPE, FILENAME, LOADPATH, SAVEPATH, STANDARDIZE,
% PERMUTE, PCA)
% constructs an object containing all information necessary for a data
% object. The nice point is that this information can be stored
% seperately without having to save the whole matrix again
%
%varlist = {'format', 'problemtype', 'name', 'filename', ...
%	   'loadpath', 'savepath', ...
%	   'zeromean', 'unitvariance', 'unitrange', 'pca', 'permute'};
%
% FORMAT      = parameter string 
% OR
% FORMAT      = {matlab, sn} (dataformat on disk)
% PROBLEMTYPE = {oneclass, twoclass, multiclass, regression} (optional)
% FILENAME
% LOADPATH      where to load the data
% SAVEPATH      also important for the data generated after training
% STANDARDIZE    flag (if set it checks if standardization already
%                happened, if not, does it)
% PERMUTE        flag (permute data)

% File:        @data/data.m
%
% Author:      Gunnar Raetsch, Alex Smola, Alexandros Karatzoglou
% Created:     01/12/98
% Updated:     25/11/02
% 


varlist = {'format', 'problemtype', 'name', 'filename', ...
	   'loadpath', 'savepath', ...
	   'zeromean', 'unitvariance', 'unitrange', 'pca', 'permute'};

emptystring = '';
defaults = {'matlab', 'twoclass', 'noname', 'noname', ...
	    emptystring, emptystring, ...
	    false, false, false, false, false};

%set defaults
d.verbose = 0;				% usually we shut up


d.info = cell2struct(defaults, varlist, 2);
d.info = read_param(varargin, d.info,varlist,defaults);

d.empty = true;				% only headers, haven't filled the object yet 

d.train.patterns = [];
d.train.labels = [];
d.train.permute = [];			% permutation index
d.valid = d.train;
d.test = d.train;

d.std = [];				% standard deviations
d.mean = [];				% means
d.pca = [];				% contains pca matrix (if available)
d.range = [];				% range (if available)

d.train.size = 0;
d.train.dim = 0;
d.train.outdim = 0;
d.train.testdim = 0;
d.valid.size = 0;
d.test.size = 0;



%if (nargin == 0)		                % do nothing
%elseif (nargin == 1) & isa(varargin{1}, 'char') % we have a char (parse it)
%  if fexist(varargin{1})	
%    disp('1');                                  % the format string describes a file name -> load it
%    load(varargin);
%    d = svlab_data;	     		        % from file
%    clear svlab_data;
%  elseif(~isempty(findstr('=',varargin{1})))
%   d.info = eval_hyper(varargin{1},d.info);
%  else
%    disp('2');
%    paramstring = varargin{1};		     % that's what it really is
%    for i=1:length(varlist)
%      d.info = setdata(d.info, paramstring, varlist{i});
%    end;
%  end;
  
%elseif (nargin == 1)
%  d.info = varargin;
%elseif (nargin == length(varlist))
%  d.info = cell2struct(varargin, varlist, 2); disp('3')
%else
%  disp('something wrong with the parameters in @data/data.m');
%end;

d = class(d, 'data');

%function data = setdata(data, d_token, d_string)

%if isempty(read_token(d_token, d_string)) == 0
%  eval(['data.',d_string,'= str2num(read_token(d_token, d_string));']);
%end;
