classdef LineString3D < Geometry3D
% An open 3D polyline composed of several line segments.
%
%   Represents a polyline defined be a series of Coords. 
%
%   Data are represented by a NV-by-3 array.
%
%   Example
%   LineString3D([0 0 0; 10 0 0; 10 10 0; 0 10 0]);
%
%   See also
%     Geometry3D, LineString2D

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-02-07,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.


%% Properties
properties
    % the set of Coords, given as a N-by-3 array of coordinates
    Coords;
    
end % end properties


%% Constructor
methods
    function obj = LineString3D(varargin)
    % Constructor for LineString3D class
    
        if ~isempty(varargin)
            var1 = varargin{1};
            if size(var1, 2) ~= 3
                error('Creating a LineString3D requires an array with three columns, not %d', size(var1, 2));
            end
            obj.Coords = var1;

        else
            obj.Coords = [];
        end
    end

end % end constructors


%% Methods specific to LineString3D
methods
    function res = smooth(obj, M)
        % Smoothes a polyline using local averaging

        % create convolution vector
        v2 = ones(M, 1) / M;
        
        % allocate memory for result
        res = zeros(size(obj.Coords));
        
        % iterate over dimensions
        for d = 1:3
            v0 = obj.Coords(1, d);
            v1 = obj.Coords(end, d);
            vals = [v0(ones(M, 1)) ; obj.Coords(:,d) ; v1(ones(M, 1))];
            resd = conv(vals, v2, 'same');
            res(:,d) = resd(M+1:end-M);
        end
        
        % convert result to LineString object
        res = LineString3D(res);
    end
    
    function l = length(obj)
        % L = length(obj);

        % compute the sum of the length of each line segment
        l = sum(sqrt(sum(diff(obj.Coords).^2, 2)));
    end
    
    function centro = centroid(obj)
        
        % compute center and length of each line segment
        centers = (obj.Coords(1:end-1,:) + obj.Coords(2:end,:))/2;
        lengths = sqrt(sum(diff(obj.Coords).^2, 2));
        
        % centroid of edge centers weighted by edge lengths
        centro = Point3D(sum(bsxfun(@times, centers, lengths), 1) / sum(lengths));
    end
    
    function nv = vertexNumber(obj)
        nv = size(obj.Coords, 1);
    end
end

%% Methods
methods
    function box = boundingBox(obj)
        % Returns the bounding box of this shape
        mini = min(obj.Coords);
        maxi = max(obj.Coords);
        box = Box3D([mini(1) maxi(1) mini(2) maxi(2) mini(3) maxi(3)]);
    end
    
    function verts = vertices(obj)
        % returns vertices as a new instance of MultiPoint3D
        verts = MultiPoint3D(obj.Coords);
    end
    
    function varargout = draw(obj, varargin)
        % Draw the current geometry, eventually specifying the style
        
        h = drawPolyline3d(obj.Coords);
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
        res = LineString3D(obj.Coords * factor);
    end
    
    function res = translate(obj, varargin)
        % Returns a translated version of this geometry
        shift = varargin{1};
        res = LineString3D(bsxfun(@plus, obj.Coords, shift));
    end
    
end % end methods

%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'LineString3D', 'coordinates', obj.Coords);
    end
end
methods (Static)
    function poly = fromStruct(str)
        % Create a new instance from a structure
        poly = LineString3D(str.coordinates);
    end
end

end % end classdef

