function writeGeometry(geom, fileName)
%WRITEGEOMETRY  One-line description here, please.
%
%   output = writeGeometry(input)
%
%   Example
%   writeGeometry
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-01,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - Cepia Software Platform.

geomStruct = formatGeometryToJson(geom);

% save into JSON format
savejson('', geomStruct, 'FileName', fileName);

