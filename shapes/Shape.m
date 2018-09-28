classdef Shape < handle
%SHAPE Contains information to draw a 2D or 3D shape 
%
%   The shape class encapsulates information about the geometry of the
%   shape (as an instance of Geometry class) and drawing options (as an
%   instance of the Style class).
%
%   Example
%     poly = Polygon2D([10 10; 20 10; 20 20; 10 20]);
%     shp = Shape(poly);
%     figure; hold on; axis equal; axis([0 50 0 50]);
%     draw(shp);
%
%   See also
%     Geometry2D, Style

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-08-13,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    % The geometry of the shape, as an instance of Geometry
    geometry;
    
    % The options for drawing the shape, as an instance of Style
    style;
    
    % visibility flag (default true)
    visible = true;
    
    % a name for identifying the shape
    name = '';
    
end % end properties


%% Constructor
methods
    function this = Shape(varargin)
    % Constructor for Shape class
    %   
    %   usage:
    %   shape = Shape(geom)
    %   shape = Shape(geom, style)
    %

        if nargin == 1
            this.geometry = varargin{1};
            this.style = createDefaultStyle(this.geometry);
            
        elseif nargin == 2
            this.geometry = varargin{1};
            this.style = varargin{2};
            
        else
            error('Wrong number of arguments for creation of Shape');
        end
        
        function style = createDefaultStyle(geom)
            if isa(geom, 'Point2D') || isa(geom, 'MultiPoint2D')
                style = Style('markerVisible', true, 'lineVisible', false);
            else
                style = Style();
            end
        end
    end

end % end constructors


%% Methods
methods
    function varargout = draw(this)
        % Draws this shape on the current axis
        h = draw(this.geometry, this.style);
        if nargout > 0
            varargout = {h};
        end
    end
end % end methods


%% Serialization methods
methods
    function str = toStruct(this)
        % Convert to a structure to facilitate serialization

        % creates a structure for geometry, including class name
        str.geometry = toStruct(this.geometry);
        if ~isfield(str.geometry, 'type')
            type = classname(this.geometry);
            warning(['geometry type not specified, use class name: ' type]);
            str.geometry.type = type;
        end
        
        % add optional style
        if ~isempty(this.style)
            str.style = toStruct(this.style);
        end
    end
    
    function write(this, fileName, varargin)
        % Write into a JSON file
        savejson('', toStruct(this), 'FileName', fileName, varargin{:});
    end
end

methods (Static)
    function shape = fromStruct(str)
        % Creates a new instance from a structure
        
        % parse geometry
        type = str.geometry.type;
        geom = eval([type '.fromStruct(str.geometry)']);
        shape = Shape(geom);
        
        % eventually parse style
        if isfield(str, 'style') && ~isempty(str.style)
            shape.style = Style.fromStruct(str.style);
        end
    end
    
    function shape = read(fileName)
        % Read a shape from a file in JSON format
        shape = Shape.fromStruct(loadjson(fileName));
    end
end

end % end classdef

