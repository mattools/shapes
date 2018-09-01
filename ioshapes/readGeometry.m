function geom = readGeometry(fileName)
%READGEOMETRY  One-line description here, please.
%
%   output = readGeometry(input)
%
%   Example
%   readGeometry
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-01,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - Cepia Software Platform.

json = loadjson(fileName);

geom = parseGeometryFromJson(json);
