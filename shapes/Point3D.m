classdef Point3D < Geometry3D
%POINT3D  A point in the 3-dimensional plane
%
%   Usage:
%   P = Point3D(X, Y, Z)
%   P = Point3D(COORDS)
%   P = Point3D(PT)
%
%   Example
%   Point3D
%
%   See also
%     Point2D

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-02-07,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    x = 0;
    y = 0;
    z = 0;
end % end properties


%% Constructor
methods
    function this = Point3D(varargin)
    % Constructor for Point3D class

        % empty constructor -> initialize to origin
        if isempty(varargin)
            return;
        end
        
        % copy constructor
        if isa(varargin{1}, 'Point3D')
            that = varargin{1};
            this.x = that.x;
            this.y = that.y;
            this.z = that.z;
            return;
        end
        
        % initialisation constructor with one argument
        if nargin == 1
            var1 = varargin{1};
            if isnumeric(var1) && ~any(size(var1) ~= [1 3])
                this.x = var1(1);
                this.y = var1(2);
                this.z = var1(3);
            else
                error('Can not parse input for Point3D');
            end
        end
        
        % initialisation from two scalar double argument
        if nargin == 3
            var1 = varargin{1};
            var2 = varargin{2};
            var3 = varargin{3};
            if isnumeric(var1) && isnumeric(var2) && isnumeric(var3) && isscalar(var1) && isscalar(var2) && isscalar(var3)
                this.x = var1;
                this.y = var2;
                this.z = var3;
            else
                error('Can not parse inputs for Point3D');
            end
        end
    end

end % end constructors


%% Methods implementing the Geometry3D interface
methods
    function box = boundingBox(this)
        % Returns the bounding box of this shape
        box = Box3D([this.x this.x this.y this.y this.z this.z]);
    end
    
    function varargout = draw(this, varargin)
        % Draw this point, eventually specifying the style
        
        h = drawPoint3d([this.x this.y this.z]);
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

%% Methods implementing the Geometry3D interface (more)
methods
    function res = scale(this, varargin)
        % Returns a scaled version of this geometry
        factor = varargin{1};
        res = Point3D([this.x this.y this.z] * factor);
    end
    
    function res = translate(this, varargin)
        % Returns a translated version of this geometry
        shift = varargin{1};
        res = Point3D(bsxfun(@plus, [this.x this.y this.z], shift));
    end    
end % end methods


%% Serialization methods
methods
    function str = toStruct(this)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'Point3D', 'x', this.x, 'y', this.y, 'z', this.z);
    end
end
methods (Static)
    function point = fromStruct(str)
        % Create a new instance from a structure
        point = Point3D(str.x, str.y, str.z);
    end
end

end % end classdef
