classdef LineString2D < Geometry2D
%LineString2D An open polyline composed of several line segments 
%
%   Represents a polyline defined be a series of coords. 
%
%   Data are represented by a NV-by-2 array.
%
%   Example
%   LineString2D([0 0; 10 0; 10 10]; 0 10]);
%
%   See also
%   Geometry2d, Polygon2D

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-08-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.


%% Properties
properties
    % the set of coords, given as a N-by-2 array of coordinates
    coords;
    
end % end properties


%% Constructor
methods
    function this = LineString2D(varargin)
    % Constructor for LineString2D class
    
        if ~isempty(varargin)
            var1 = varargin{1};
            if size(var1, 2) ~= 2
                error('Creating a linestring requires an array with two columns, not %d', size(var1, 2));
            end
            this.coords = var1;

        else
            this.coords = [];
        end
    end

end % end constructors


%% Methods
methods
    function box = boundingBox(this)
        % Returns the bounding box of this shape
        mini = min(this.coords);
        maxi = max(this.coords);
        box = Box2D([mini(1) maxi(1) mini(2) maxi(2)]);
    end
    
    function verts = vertices(this)
        % returns vertices as a new instance of MultiPoint2D
        verts = MultiPoint2D(this.coords);
    end
    
    function varargout = draw(this, varargin)
        % Draw the current geometry, eventually specifying the style
        
        h = drawPolyline(this.coords);
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
    
    function res = scale(this, varargin)
        % Returns a scaled version of this geometry
        factor = varargin{1};
        res = LineString2D(this.coords * factor);
    end
    
    function res = translate(this, varargin)
        % Returns a translated version of this geometry
        shift = varargin{1};
        res = LineString2D(bsxfun(@plus, this.coords, shift));
    end
    
    function res = rotate(this, angle, varargin)
        % Returns a rotated version of this polyline
        %
        % POLY2 = rotate(POLY, THETA)
        % POLY2 = rotate(POLY, THETA, CENTER)
        % THETA is given in degrees, in counter-clockwise order.
        
        origin = [0 0];
        if ~isempty(varargin)
            origin = varargin{1};
        end
        
        rot = createRotation(origin, deg2rad(angle));
        verts = transformPoint(this.coords, rot);
        
        res = LineString2D(verts);
    end
end % end methods

end % end classdef

