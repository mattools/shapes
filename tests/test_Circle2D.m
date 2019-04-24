function tests = test_Circle2D
%TEST_POINT2D  Test case for the file Circle2D
%
%   Test case for the file Circle2D
%
%   Example
%   test_Circle2D
%
%   See also
%   Circle2D
%
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_Constructor_OneArg(testCase) %#ok<*DEFNU>
% Test call of function without argument

circ = Circle2D([5 4 3]);
assertEqual(testCase, circ.CenterX, 5);
assertEqual(testCase, circ.CenterY, 4);
assertEqual(testCase, circ.Radius, 3);

function test_Serialize(testCase)
% Test call of function without argument

circ = Circle2D([5 4], 3);
str = toStruct(circ);
circ2 = Circle2D.fromStruct(str);
assertEqual(testCase, circ2.CenterX, circ.CenterX);
assertEqual(testCase, circ2.CenterY, circ.CenterY);
assertEqual(testCase, circ2.Radius, circ.Radius);
