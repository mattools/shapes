function test_suite = test_ImageNode
%TEST_IMAGENODE  Test case for the file ImageNode
%
%   Test case for the file ImageNode
%
%   Example
%   test_ImageNode
%
%   See also
%   ImageNode

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-10-15,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2018 INRA - Cepia Software Platform.

test_suite = buildFunctionHandleTestSuite(localfunctions);

function test_Simple(testCase) %#ok<*DEFNU>
% Test call of function without argument

node = ImageNode('rice.png');
readImageData(node);

assertTrue(~isempty(node.ImageData));

