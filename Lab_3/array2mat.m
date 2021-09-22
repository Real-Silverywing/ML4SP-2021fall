function [outputArg1] = array2mat(array)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
outputArg1 = uint8(255*mat2gray(array));
end

