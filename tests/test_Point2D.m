function tests = test_Point2D
%TEST_POINT2D  Test case for the file Point2D
%
%   Test case for the file Point2D
%
%   Example
%   test_Point2D
%
%   See also
%   Point2D
%
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_Constructor_Single(testCase) %#ok<*DEFNU>
% Test call of function without argument

p = Point2D([3 4]);
assertEqual(testCase, 3, p.X);
assertEqual(testCase, 4, p.Y);

function test_Serialize(testCase)
% Test call of function without argument

p = Point2D([3 4]);
str = toStruct(p);
p2 = Point2D.fromStruct(str);
assertEqual(testCase, 3, p2.X);
assertEqual(testCase, 4, p2.Y);

