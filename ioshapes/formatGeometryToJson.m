function geomStruct = formatGeometryToJson(geometry)
%FORMATGEOMETRYTOJSON Format a geometry to a JSON structure
%
%   output = formatGeometryToJson(input)
%
%   Example
%   formatGeometryToJson
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-01,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - Cepia Software Platform.

% check class validity
if ~isa(geometry, 'Geometry2D')
    error('Requires an instance of Geometry2D');
end

% convert to structure
if isa(geometry, 'Polygon2D')
    % process polygon
    geomStruct = struct('type', 'Polygon2D', 'coordinates', geometry.coords);
    
elseif isa(geometry, 'LineString2D')
    % process polylines (LineString2D)
    geomStruct = struct('type', 'LineString2D', 'coordinates', geometry.coords);

else
    error('Can not manage geometry of class %s', classname(geometry)); 
end
