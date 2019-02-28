classdef Shape < handle
%SHAPE Contains information to draw a 2D or 3D shape 
%
%   The shape class encapsulates information about the Geometry of the
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
    % The Geometry of the shape, as an instance of Geometry
    Geometry;
    
    % The options for drawing the shape, as an instance of Style
    Style;
    
    % visibility flag (default true)
    Visible = true;
    
    % a Name for identifying the shape
    Name = '';
    
end % end properties


%% Constructor
methods
    function obj = Shape(varargin)
        % Constructor for Shape class
        %
        %   usage:
        %   shape = Shape(geom)
        %   shape = Shape(geom, Style)
        %

        if nargin == 1
            var1 = varargin{1};
            if isa(var1, 'Shape')
                % copy constructor
                obj.Geometry = var1.Geometry; % Geometry is not duplicated
                obj.Style = Style(var1.Style);
                obj.Visible = var1.Visible;
                obj.Name = var1.Name;
                
            else
                % initialisation constructor
                obj.Geometry = varargin{1};
                obj.Style = createDefaultStyle(obj.Geometry);
            end
            
        elseif nargin == 2
            % initialisation constructor with two arguments
            obj.Geometry = varargin{1};
            obj.Style = varargin{2};
            
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
    function varargout = draw(obj)
        % Draws obj shape on the current axis
        h = draw(obj.Geometry, obj.Style);
        if nargout > 0
            varargout = {h};
        end
    end
end % end methods


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization

        % add the Name only if not null
        if ~isempty(obj.Name)
            str.name = obj.Name;
        end
        
        % add optional Style
        if ~isempty(obj.Style)
            str.style = toStruct(obj.Style);
        end

        % creates a structure for Geometry, including class Name
        str.geometry = toStruct(obj.Geometry);
        if ~isfield(str.geometry, 'type')
            type = classname(obj.Geometry);
            warning(['Geometry type not specified, use class Name: ' type]);
            str.geometry.type = type;
        end
    end
    
    function write(obj, fileName, varargin)
        % Write into a JSON file
        savejson('', toStruct(obj), 'FileName', fileName, varargin{:});
    end
end

methods (Static)
    function shape = fromStruct(str)
        % Creates a new instance from a structure
        
        % parse Geometry
        type = str.geometry.type;
        geom = eval([type '.fromStruct(str.geometry)']);
        shape = Shape(geom);
        
        % parse the optionnal Name
        if isfield(str, 'name') && ~isempty(str.name)
            shape.Name = str.name;
        end

        % eventually parse Style
        if isfield(str, 'style') && ~isempty(str.style)
            shape.Style = Style.fromStruct(str.style);
        end
    end
    
    function shape = read(fileName)
        % Read a shape from a file in JSON format
        shape = Shape.fromStruct(loadjson(fileName));
    end
end

end % end classdef

