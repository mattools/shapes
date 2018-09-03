function testSuite = test_Polygon2D(varargin)
%TEST_POLYGON2D  Test case for the file Polygon2D
%
%   Test case for the file Polygon2D

%   Example
%   test_Polygon2D
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2018-09-01,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - Cepia Software Platform.

testSuite = buildFunctionHandleTestSuite(localfunctions);

function test_Constructor %#ok<*DEFNU>
% Test call of function without argument

vertices = [10 10; 20 10; 20 20; 10 20];
poly = Polygon2D(vertices);
assertEqual(4, size(poly.coords, 1));

function test_perimeter_square %#ok<*DEFNU>
% Test call of function without argument

vertices = [10 10; 20 10; 20 20; 10 20];
poly = Polygon2D(vertices);
exp = 40;

perim = perimeter(poly);

assertEqual(exp, perim, .01);

function test_area_square %#ok<*DEFNU>
% Test call of function without argument

vertices = [10 10; 20 10; 20 20; 10 20];
poly = Polygon2D(vertices);
exp = 100;

a = area(poly);

assertEqual(exp, a, .01);

