classdef Polygon2D < Geometry2D
% A polygon in the plane.
%
%   Represents a polygon defined be a series of Coords. 
%
%   Data are represented by a NV-by-2 array.
%
%   Example
%   Polygon2D([0 0; 10 0; 10 10; 0 10]);
%
%   See also
%     Geometry2D, LinearRing2D

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-08-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.


%% Properties
properties
    % the set of vertex coordinates, given as a N-by-2 array of double
    Coords;
    
end % end properties


%% Constructor
methods
    function obj = Polygon2D(varargin)
    % Constructor for Polygon2D class
    
        if ~isempty(varargin)
            var1 = varargin{1};
            if size(var1, 2) ~= 2
                error('Creating a polygon requires an array with two columns, not %d', size(var1, 2));
            end
            obj.Coords = var1;

        else
            obj.Coords = [];
        end
    end

end % end constructors

%% Methods specific to Polygon2D
methods
    function centro = centroid(obj)
        % Computes the centroid of this polygon
        
        % isolate coordinates
        px = obj.Coords(:,1);
        py = obj.Coords(:,2);

        % indices of next vertices
        N = length(obj.Coords);
        iNext = [2:N 1];
        
        % compute cross products
        common = px .* py(iNext) - px(iNext) .* py;
        sx = sum((px + px(iNext)) .* common);
        sy = sum((py + py(iNext)) .* common);
        
        % area and centroid
        area = sum(common) / 2;
        centro = Point2D([sx sy] / 6 / area);
    end
    
    function a = area(obj)
        % Computes the area of this polygon
        
        % isolate coordinates
        px = obj.Coords(:,1);
        py = obj.Coords(:,2);

        % indices of next vertices
        N = length(obj.Coords);
        iNext = [2:N 1];
        
        % compute area (vectorized version)
        a = sum(px .* py(iNext) - px(iNext) .* py) / 2;
    end
    
    function p = perimeter(obj)
        % Computes the perimeter (boundary length) of this polygon
        dp = diff(obj.Coords([1:end 1], :), 1, 1);
        p = sum(hypot(dp(:, 1), dp(:, 2)));
    end
    
    function verts = vertices(obj)
        % Returns vertices as a new instance of MultiPoint2D
        verts = MultiPoint2D(obj.Coords);
    end
end

%% Methods implementing the Geometry2D interface
methods
    function res = transform(obj, transform)
        % Applies a geometric transform to this geometry
        res = Polygon2D(transformCoords(transform, obj.Coords));
    end
    
    function box = boundingBox(obj)
        % Returns the bounding box of this shape
        mini = min(obj.Coords);
        maxi = max(obj.Coords);
        box = Box2D([mini(1) maxi(1) mini(2) maxi(2)]);
    end
    
    function varargout = draw(obj, varargin)
        % Draw the current geometry, eventually specifying the style
        
        if nargin > 1
            style = varargin{1};
            if ~isa(style, 'Style')
                error('Second argument must be a Style');
            end
            
            % fill interior
            if style.FillVisible
                h = fillPolygon(obj.Coords);
                apply(style, h);
            end
            
            % draw outline
            if style.LineVisible
                h = drawPolygon(obj.Coords);
                apply(style, h);
            end
            
            if style.MarkerVisible
                h = drawPoint(obj.Coords);
                apply(style, h);
            end
            
        else
            h = drawPolygon(obj.Coords);
        end
        
        if nargout > 0
            varargout = {h};
        end
    end
end

%% Methods implementing the Geometry2D interface (more)
methods
    function res = scale(obj, varargin)
        % Returns a scaled version of this geometry
        factor = varargin{1};
        res = Polygon2D(obj.Coords * factor);
    end
    
    function res = translate(obj, varargin)
        % Returns a translated version of this geometry
        shift = varargin{1};
        res = Polygon2D(bsxfun(@plus, obj.Coords, shift));
    end
    
    function res = rotate(obj, angle, varargin)
        % Returns a rotated version of this polygon
        %
        % POLY2 = rotate(POLY, THETA)
        % POLY2 = rotate(POLY, THETA, CENTER)
        % THETA is given in degrees, in counter-clockwise order.
        
        origin = [0 0];
        if ~isempty(varargin)
            origin = varargin{1};
        end
        
        rot = createRotation(origin, deg2rad(angle));
        verts = transformPoint(obj.Coords, rot);
        
        res = Polygon2D(verts);
    end
end % end methods

%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization
        str = struct('Type', 'Polygon2D', 'Coordinates', obj.Coords);
    end
end
methods (Static)
    function poly = fromStruct(str)
        % Create a new instance from a structure
        poly = Polygon2D(str.Coordinates);
    end
end

end % end classdef

