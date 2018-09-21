function testSuite = test_Shape(varargin)
%TEST_SHAPE  Test case for the file Shape
%
%   Test case for the file Shape

%   Example
%   test_Shape
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-19,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - Cepia Software Platform.

testSuite = buildFunctionHandleTestSuite(localfunctions);

function test_Simple %#ok<*DEFNU>
% Test call of function without argument

coords = [0 0;1 0; 1 1;0 1];
geom = Polygon2D(coords);

shape = Shape(geom);
shape.geometry;


function test_write
% Test call of function without argument

coords = [10 10; 30 10; 30 20; 20 20; 20 30 ;10 30];
geom = Polygon2D(coords);
shape = Shape(geom);

write(shape, 'simplePolygon01.shape');


function test_read
% Test call of function without argument

shape = Shape.read('simplePolygon01.shape');
geom = shape.geometry;
assertTrue(isa(geom, 'Polygon2D'));

coords = geom.coords;
assertEqual(6, size(coords, 1));





