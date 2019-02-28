function testSuite = test_MultiPoint3D(varargin)
%TEST_POINT3D  Test case for the file MultiPoint3D
%
%   Test case for the file MultiPoint3D

%   Example
%   test_MultiPoint3D
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

v = [0 0 0;1 0 0;0 1 0;0 0 1];
pts = MultiPoint3D(v); %#ok<NASGU>



function test_Serialize(testCase)
% Test call of function without argument

v = [0 0 0;1 0 0;0 1 0;0 0 1];
pts = MultiPoint3D(v);

str = toStruct(pts);

pts2 = MultiPoint3D.fromStruct(str);
assertElementsAlmostEqual(pts.Coords, pts2.Coords);




