function testSuite = test_Point3D(varargin)
%TEST_POINT3D  Test case for the file Point3D
%
%   Test case for the file Point3D

%   Example
%   test_Point3D
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-02-07,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - Cepia Software Platform.

testSuite = buildFunctionHandleTestSuite(localfunctions);

function test_Constructor_Single(testCase) %#ok<*DEFNU>
% Test call of function without argument

p = Point3D([5 4 3]);
assertEqual(5, p.X);
assertEqual(4, p.Y);
assertEqual(3, p.Z);

function test_Serialize(testCase)
% Test call of function without argument

p = Point3D([5 4 3]);
str = toStruct(p);
p2 = Point3D.fromStruct(str);
assertEqual(5, p2.X);
assertEqual(4, p2.Y);
assertEqual(3, p2.Z);




