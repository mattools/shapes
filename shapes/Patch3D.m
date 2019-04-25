classdef Patch3D < Geometry3D
%PATCH3D A 3D parametric defined by three arrays x, y, and z
%
%   Class Patch3D
%
%   Example
%   Patch3D
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-04-25,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    X;
    Y;
    Z;
end % end properties


%% Constructor
methods
    function obj = Patch3D(varargin)
    % Constructor for Patch3D class

        if nargin == 3
            obj.X = varargin{1};
            obj.Y = varargin{2};
            obj.Z = varargin{3};
        end
    end

end % end constructors


%% Methods
methods
    function box = boundingBox(obj)
        % Returns the bounding box of this shape
        xmin = min(obj.X(:));
        xmax = max(obj.X(:));
        ymin = min(obj.Y(:));
        ymax = max(obj.Y(:));
        zmin = min(obj.Z(:));
        zmax = max(obj.Z(:));
        box = Box3D([xmin xmax ymin ymax zmin zmax]);
    end
    
%     function verts = vertices(obj)
%         % returns vertices as a new instance of MultiPoint3D
%         verts = MultiPoint3D(obj.Coords);
%     end
    
    function varargout = draw(obj, varargin)
        % Draw the current geometry, eventually specifying the style
        
        h = surf('XData', obj.X, 'YData', obj.Y, 'ZData', obj.Z);
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
        res = Patch3D(obj.X * factor, obj.Y * factor, obj.Z * factor);
    end
    
    function res = translate(obj, shift)
        % Returns a translated version of this geometry
        res = Patch3D(obj.X + shift(1), obj.Y + shift(2), obj.Z + shift(3));
    end
    
end % end methods

%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'Patch3D', 'x', obj.X, 'y', obj.Y, 'z', obj.Z);
    end
end
methods (Static)
    function obj = fromStruct(str)
        % Create a new instance from a structure
        obj = Patch3D(str.x, str.y, str.z);
    end
end

end % end classdef

