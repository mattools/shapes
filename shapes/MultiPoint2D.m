classdef MultiPoint2D < Geometry2D
%MULTIPOINT2D A set of points in the plane
%
%   Represents a set of Coordinates. 
%
%   Data are represented by a NV-by-2 array.
%
%   Example
%   MultiPoint2D([0 0; 10 0; 10 10]; 0 10]);
%
%   See also
%   Geometry2D, Polygon2D, LineString2D

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-08-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.


%% Properties
properties
    % the point coordinates, given as a N-by-2 array of double
    Coords;
    
end % end properties


%% Constructor
methods
    function obj = MultiPoint2D(varargin)
    % Constructor for MultiPoint2D class
    
        if ~isempty(varargin)
            var1 = varargin{1};
            if size(var1, 2) ~= 2
                error('Creating a MultiPoint requires an array with two columns, not %d', size(var1, 2));
            end
            obj.Coords = var1;

        else
            obj.Coords = [];
        end
    end

end % end constructors

%% Methods specific to MultiPoint2D
methods
    function centro = centroid(obj)
        % compute centroid of the points within obj multi-point
        centro = Point2D(mean(obj.Coords, 1));
    end
end

%% Methods
methods
    function box = boundingBox(obj)
        % Returns the bounding box of this shape
        mini = min(obj.Coords);
        maxi = max(obj.Coords);
        box = Box2D([mini(1) maxi(1) mini(2) maxi(2)]);
    end
    
    function varargout = draw(obj, varargin)
        % Draw the current geometry, eventually specifying the style
        
        h = drawPoint(obj.Coords);
        if nargin > 1
            var1 = varargin{1};
            if isa(var1, 'Style')
                apply(var1, h);
            end
        end
        
        if nargout > 0
            varargout = {h};
        end
    end
    
    function res = scale(obj, varargin)
        % Returns a scaled version of this geometry
        factor = varargin{1};
        res = MultiPoint2D(obj.Coords * factor);
    end
    
    function res = translate(obj, varargin)
        % Returns a translated version of this geometry
        shift = varargin{1};
        res = MultiPoint2D(bsxfun(@plus, obj.Coords, shift));
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
        
        res = MultiPoint2D(verts);
    end
end % end methods

%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'MultiPoint2D', 'coordinates', obj.Coords);
    end
end
methods (Static)
    function poly = fromStruct(str)
        % Create a new instance from a structure
        poly = MultiPoint2D(str.coordinates);
    end
end

end % end classdef

