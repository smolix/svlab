function f_data=foobar(varargin);

for i=1:nargin
  disp(varargin(i));
  cell2struct(varargin, {'a', 'b', 'c'}, 2)
end;
