function writeStyle(style, fileName)
%WRITESTYLE  One-line description here, please.
%
%   output = writeStyle(input)
%
%   Example
%   writeStyle
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-02,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - Cepia Software Platform.

styleStruct = formatStyleToJson(style);

% save into JSON format
savejson('', styleStruct, 'FileName', fileName);
