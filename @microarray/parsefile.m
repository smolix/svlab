function [tok,line] = parsefile(microVar,gprFile) %,tiffFiles)
% function X = parsefile(microVar,gprFile,tiffFiles)
%
% A parser for Spot output files in Tiff format
%
% This function parses the gprFile and from this extracts
% the microarray spot locations. Then it takes the filenames
% from the array of strings tiffFiles, reads in each file,
% extracts the spots at the locations specified in the gprFile, 
% vectorizes each spot, and returns a dataset where each column is
% a vectorized spot.
%
% File:        @microarray/microarray.m
%
% Author:      Ben O'Loghlin
% Created:     07/03/01
% Modified:   
%
% This code is released under the GNU Public License
% Copyright by The Australian National University

% parse the gpr file
 
%strip header
gprFD = fopen(gprFile, 'r');
line = fgets(gprFD);
[tok, line] = strtok(line);
while ~strcmp(tok,'"Block"')
   line = fgets(gprFD);
   [tok, line] = strtok(line);
end  %while

