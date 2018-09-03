classdef Point2D < Geometry2D
%POINT2D  A point in the 2-dimensional plane
%
%   Usage:
%   P = Point2D(X, Y)
%   P = Point2D(COORDS)
%   P = Point2D(PT)
%
%   Example
%   Point2D
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-01,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    x = 0;
    y = 0;
end % end properties


%% Constructor
methods
    function this = Point2D(varargin)
        % Constructor for Point2D class
        
        % empty constructor -> initialize to origin
        if isempty(varargin)
            return;
        end
        
        % copy constructor
        if isa(varargin{1}, 'Point2D')
            that = varargin{1};
            this.x = that.x;
            this.y = that.y;
            return;
        end
        
        % initialisation constructor with one argument
        if nargin == 1
            var1 = varargin{1};
            if isnumeric(var1) && ~any(size(var1) ~= [1 2])
            else
                error('Can not parse input for Point2D');
            end
        end
        
        % initialisation from two scalar double argument
        if nargin == 2
            var1 = varargin{1};
            var2 = varargin{2};
            if isnumeric(var1) && isnumeric(var2) && isscalar(var1) && isscalar(var2)
                this.x = varargin{1};
                this.y = varargin{2};
            else
                error('Can not parse inputs for Point2D');
            end
        end
    end

end % end constructors


%% Methods implementing the Geometry2D interface
methods
    function box = boundingBox(this)
        % Returns the bounding box of this shape
        box = Box2D([this.x this.x this.y this.y]);
    end
    
    function varargout = draw(this, varargin)
        % Draw this point, eventually specifying the style
        
        h = drawPoint([this.x this.y]);
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
end

%% Methods implementing the Geometry2D interface (more)
methods
    
    function res = scale(this, varargin)
        % Returns a scaled version of this geometry
        factor = varargin{1};
        res = Point2D([this.x this.y] * factor);
    end
    
    function res = translate(this, varargin)
        % Returns a translated version of this geometry
        shift = varargin{1};
        res = Point2D(bsxfun(@plus, [this.x this.y], shift));
    end
    
    function res = rotate(this, angle, varargin)
        % Returns a rotated version of this point
        %
        % PT2 = rotate(PT, THETA)
        % PT2 = rotate(PT, THETA, CENTER)
        % THETA is given in degrees, in counter-clockwise order.
        
        origin = [0 0];
        if ~isempty(varargin)
            origin = varargin{1};
        end
        
        rot = createRotation(origin, deg2rad(angle));
        verts = transformPoint([this.x this.y], rot);
        
        res = Point2D(verts);
    end
end % end methods

end % end classdef

