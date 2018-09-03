function style = readStyle(fileName)
%READSTYLE Read Style instance from a JSON file
%
%   output = readStyle(input)
%
%   Example
%   readStyle
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.

json = loadjson(fileName);

style = parseStyleFromJson(json);
