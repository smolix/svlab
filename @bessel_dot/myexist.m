function [ans]= myexist(which,type)


  ans=exist(which,type);
  if strcmp(which,'ridge') ans=0; end;
  if strcmp(which,'poly') ans=0; end;
  if strcmp(which,'alpha') ans=0; end;

