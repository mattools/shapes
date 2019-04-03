function tests = test_GroupNode
%TEST_GROUPNODE  Test case for the file GroupNode
%
%   Test case for the file GroupNode
%
%   Example
%   test_GroupNode
%
%   See also
%   GroupNode

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-04-03,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - Cepia Software Platform.

tests = functiontests(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument

node = GroupNode();

geom = Point2D([4, 3]);
shape = ShapeNode(geom);

add(node, shape);

assertEqual(testCase, 1, length(node.Children));
