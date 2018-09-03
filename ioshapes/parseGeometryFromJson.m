function geom = parseGeometryFromJson(json)
%PARSEGEOMETRYFROMJSON Parse JSON structure into Style
%
%   output = parseGeometryFromJson(input)
%
%   Example
%   parseGeometryFromJson
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-01,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - Cepia Software Platform.


if strcmp(type, 'Polygon2D')
    % check if required fields exist
    if ~isfield(json, 'coordinates')
        error('Requires a coordinates field');
    end
    coords = json.coordinates;
    % creates the geometry
    geom = Polygon2D(coords);
    
else
    error(['Unable to manage type: ' type]);
end
