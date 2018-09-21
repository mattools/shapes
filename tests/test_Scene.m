function testSuite = test_Scene(varargin)
%TEST_SCENE  Test case for the file Scene
%
%   Test case for the file Scene

%   Example
%   test_Scene
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-20,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - Cepia Software Platform.

testSuite = buildFunctionHandleTestSuite(localfunctions);

function test_Creation %#ok<*DEFNU>
% Test call of function without argument
scene = Scene();
assertTrue(isa(scene, 'Scene'));

function test_read

scene = Scene.read('kandinsky.scene');
assertTrue(isa(scene, 'Scene'));
assertEqual(3, length(scene.shapes));


function test_viewBox
% test conversion viewbox to scene axis limits
box = [1 2 3 4 5 6];
scene = Scene();
setViewBox(scene, box);
box2 = viewBox(scene);
assertElementsAlmostEqual(box, box2);

