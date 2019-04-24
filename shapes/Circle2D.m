classdef Circle2D < Geometry2D
%CIRCLE2D  One-line description here, please.
%
%   Class Circle2D
%
%   Example
%   Circle2D
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-04-24,    using Matlab 9.6.0.1072779 (R2019a)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    CenterX = 0;
    CenterY = 0;
    Radius = 1;
    
end % end properties


%% Constructor
methods
    function obj = Circle2D(varargin)
    % Constructor for Circle2D class

        switch nargin
            case 0
                % nothing to do
            case 1
                var1 = varargin{1};
                if size(var1, 2) ~= 3
                    error('Creating a circle requires an array with three columns, not %d', size(var1, 2));
                end
                obj.CenterX = var1(1);
                obj.CenterY = var1(2);
                obj.Radius = var1(3);
            case 2
                var1 = varargin{1};
                if size(var1, 2) ~= 2
                    error('Creating a circle requires an array with two columns, not %d', size(var1, 2));
                end
                obj.CenterX = var1(1);
                obj.CenterY = var1(2);
                obj.Radius = varargin{2};
        end
    end

end % end constructors


%% Methods specific to Circle2D
methods
    function center = center(obj)
        % returns the center of this circle as a Point2D
        center = Point2D(obj.CenterX, obj.CenterY);
    end
end

%% Methods
methods
    function res = transform(obj, transform) %#ok<STOUT>
        % Applies a geometric transform to this geometry
        error('Transform not implemented for Circles');
    end
    
    function box = boundingBox(obj)
        % Returns the bounding box of this geometry
        extX = [obj.CenterX - obj.Radius obj.CenterX + obj.Radius];
        extY = [obj.CenterY - obj.Radius obj.CenterY + obj.Radius];
        box = Box2D([extX extY]);
    end
    
    function varargout = draw(obj, varargin)
        % Draw the current geometry, eventually specifying the style
        
        h = drawCircle([obj.CenterX obj.CenterY obj.Radius]);
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
    
    function res = scale(obj, factor)
        % Returns a scaled version of this geometry
        res = Circle2D([obj.CenterX obj.CenterY obj.Radius] * factor);
    end
    
    function res = translate(obj, shift)
        % Returns a translated version of this geometry
        res = Circle2D([obj.CenterX obj.CenterY] + shift,  obj.Radius);
    end
    
    function res = rotate(obj, angle, varargin)
        % Returns a rotated version of this polyline
        %
        % POLY2 = rotate(POLY, THETA)
        % POLY2 = rotate(POLY, THETA, CENTER)
        % THETA is given in degrees, in counter-clockwise order.
        
        center2 = rotate(center(obj), angle, varargin{:});
        res = Circle2D([center2.X center2.Y obj.Radius]);
    end
end % end methods

%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'Circle2D', 'center', [obj.CenterX obj.CenterY], 'radius', obj.Radius);
    end
end
methods (Static)
    function circ = fromStruct(str)
        % Create a new instance from a structure
        circ = Circle2D([str.center str.radius]);
    end
end

end % end classdef

