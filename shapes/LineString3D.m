classdef LineString3D < Geometry3D
%LineString3D An open 3D polyline composed of several line segments 
%
%   Represents a polyline defined be a series of coords. 
%
%   Data are represented by a NV-by-3 array.
%
%   Example
%   LineString3D([0 0 0; 10 0 0; 10 10 0]; 0 10 0]);
%
%   See also
%   Geometry3D, LineString3D

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-02-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.


%% Properties
properties
    % the set of coords, given as a N-by-3 array of coordinates
    coords;
    
end % end properties


%% Constructor
methods
    function this = LineString3D(varargin)
    % Constructor for LineString3D class
    
        if ~isempty(varargin)
            var1 = varargin{1};
            if size(var1, 2) ~= 3
                error('Creating a LineString3D requires an array with three columns, not %d', size(var1, 2));
            end
            this.coords = var1;

        else
            this.coords = [];
        end
    end

end % end constructors


%% Methods specific to LineString3D
methods
    function centro = centroid(this)
        
        % compute center and length of each line segment
        centers = (this.coords(1:end-1,:) + this.coords(2:end,:))/2;
        lengths = sqrt(sum(diff(this.coords).^2, 2));
        
        % centroid of edge centers weighted by edge lengths
        centro = Point3D(sum(bsxfun(@times, centers, lengths), 1) / sum(lengths));
    end
end

%% Methods
methods
    function box = boundingBox(this)
        % Returns the bounding box of this shape
        mini = min(this.coords);
        maxi = max(this.coords);
        box = Box3D([mini(1) maxi(1) mini(2) maxi(2) mini(3) maxi(3)]);
    end
    
    function verts = vertices(this)
        % returns vertices as a new instance of MultiPoint3D
        verts = MultiPoint3D(this.coords);
    end
    
    function varargout = draw(this, varargin)
        % Draw the current geometry, eventually specifying the style
        
        h = drawPolyline3d(this.coords);
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
        res = LineString3D(this.coords * factor);
    end
    
    function res = translate(this, varargin)
        % Returns a translated version of this geometry
        shift = varargin{1};
        res = LineString3D(bsxfun(@plus, this.coords, shift));
    end
    
end % end methods

%% Serialization methods
methods
    function str = toStruct(this)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'LineString3D', 'coordinates', this.coords);
    end
end
methods (Static)
    function poly = fromStruct(str)
        % Create a new instance from a structure
        poly = LineString3D(str.coordinates);
    end
end

end % end classdef

