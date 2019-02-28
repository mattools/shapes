function testSuite = test_Style(varargin)
%TEST_STYLE  Test case for the file Style
%
%   Test case for the file Style

%   Example
%   test_Style
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2018-09-19,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - Cepia Software Platform.

testSuite = buildFunctionHandleTestSuite(localfunctions);

function test_EmptyConstructor %#ok<*DEFNU>
% Test call of function without argument

style = Style();
style.LineWidth;


function test_ArgumentConstructor %#ok<*DEFNU>
% Test call of function without argument

style = Style('LineStyle', '-', 'linewidth', 2);
style.LineWidth;


function test_read
% Test call of function without argument

style = Style.read('style1.style');
assertTrue(isa(style, 'Style')); 