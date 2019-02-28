classdef Geometry < handle
%GEOMETRY Abstract class for geometries whatever the dimension
%
%   Class Geometry
%
%   Example
%   Geometry
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2018-08-13,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
end % end constructors


%% Methods
methods
end % end methods

%% Serialization methods
methods
    function write(obj, fileName, varargin)
        % Writes geometry into a JSON file
        % 
        % Requires implementation of the "toStruct" method.
        
        if exist('savejson', 'file') == 0
            error('Requires the ''jsonlab'' library');
        end
        if ~ismethod(obj, 'toStruct')
            error('Requires implementation of the ''toStruct'' method');
        end
        
        savejson('', toStruct(obj), 'FileName', fileName, varargin{:});
    end
end

methods (Static)
    function geom = fromStruct(str)
        % Creates a new transform instance from a structure
        
        % check existence of 'type' field
        if ~isfield(str, 'type')
            error('Requires a field with name "type"');
        end
        type = str.type;

        % parse transform
        try
            geom = eval([type '.fromStruct(str)']);
        catch ME
            error(['Unable to parse Geometry with type: ' type]);
        end
    end
    
    function geom = read(fileName)
        % Reads a geometry from a file in JSON format
        if exist('loadjson', 'file') == 0
            error('Requires the ''jsonlab'' library');
        end
        geom = Geometry.fromStruct(loadjson(fileName));
    end
end

end % end classdef

