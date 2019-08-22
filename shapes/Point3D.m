classdef Point3D < Geometry3D
% A point in the 3-dimensional space.
%
%   Usage:
%   P = Point3D(COORDS)
%   where COORDS is a 1-by-3 array of numeric values
%   P = Point3D(X, Y, Z)
%   where each of X, Y and Z are numeric scalars
%   P = Point3D(PT)
%   where PT is another instance of Point3D
%
%   Example
%   Point3D
%
%   See also
%     Geometry3D, MultiPoint3D, Point2D

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-02-07,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    X = 0;
    Y = 0;
    Z = 0;
end % end properties


%% Constructor
methods
    function obj = Point3D(varargin)
    % Constructor for Point3D class

        % empty constructor -> initialize to origin
        if isempty(varargin)
            return;
        end
        
        % copy constructor
        if isa(varargin{1}, 'Point3D')
            that = varargin{1};
            obj.X = that.X;
            obj.Y = that.Y;
            obj.Z = that.Z;
            return;
        end
        
        % initialisation constructor with one argument
        if nargin == 1
            var1 = varargin{1};
            if isnumeric(var1) && ~any(size(var1) ~= [1 3])
                obj.X = var1(1);
                obj.Y = var1(2);
                obj.Z = var1(3);
            else
                error('Can not parse input for Point3D');
            end
        end
        
        % initialisation from three scalar numeric arguments
        if nargin == 3
            var1 = varargin{1};
            var2 = varargin{2};
            var3 = varargin{3};
            if isnumeric(var1) && isnumeric(var2) && isnumeric(var3) && isscalar(var1) && isscalar(var2) && isscalar(var3)
                obj.X = var1;
                obj.Y = var2;
                obj.Z = var3;
            else
                error('Can not parse inputs for Point3D');
            end
        end
    end

end % end constructors


%% Methods implementing the Geometry3D interface
methods
    function box = boundingBox(obj)
        % Returns the bounding box of this shape
        box = Box3D([obj.X obj.X obj.Y obj.Y obj.Z obj.Z]);
    end
    
    function h = draw(varargin)
        % Draws this point, eventually specifying the style

        % extract handle of axis to draw in
        if numel(varargin{1}) == 1 && ishghandle(varargin{1}, 'axes')
            hAx = varargin{1};
            varargin(1)=[];
        else
            hAx = gca;
        end

        % extract the point instance from the list of input arguments
        obj = varargin{1};
        varargin(1) = [];
        
        % extract optional drawing options
        options = {};
        if nargin > 1 && ischar(varargin{1})
            options = varargin;
            varargin = {};
        end
        
        % draw the geometric primitive
        hh = plot3(hAx, obj.X, obj.Y, obj.Z, options{:});

        % optionnally add style processing
        if ~isempty(varargin) && isa(varargin{1}, 'Style');
            apply(varargin{1}, hh);
        end
        
        % format output argument
        if nargout > 0
            h = hh;
        end
    end
end

%% Methods implementing the Geometry3D interface (more)
methods
    function res = scale(obj, varargin)
        % Returns a scaled version of this geometry
        factor = varargin{1};
        res = Point3D([obj.X obj.Y obj.Z] * factor);
    end
    
    function res = translate(obj, varargin)
        % Returns a translated version of this geometry
        shift = varargin{1};
        res = Point3D(bsxfun(@plus, [obj.X obj.Y obj.Z], shift));
    end    
end % end methods


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'Point3D', 'x', obj.X, 'y', obj.Y, 'z', obj.Z);
    end
end
methods (Static)
    function point = fromStruct(str)
        % Create a new instance from a structure
        point = Point3D([str.x, str.y, str.z]);
    end
end

end % end classdef
