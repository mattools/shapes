classdef MultiPoint3D < handle
% A set of points in the 3D space.
%
%   Class MultiPoint3D
%
%   Example
%   MultiPoint3D
%
%   See also
%     Point3D, MultiPoint2D

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-02-07,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % the vertex coordinates, given as a N-by-3 array of double
    Coords;
    
end % end properties


%% Constructor
methods
    function obj = MultiPoint3D(varargin)
    % Constructor for MultiPoint3D class

        if ~isempty(varargin)
            var1 = varargin{1};
            if size(var1, 2) ~= 3
                error('Creating a 3D MultiPoint requires an array with three columns, not %d', size(var1, 2));
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
        centro = Point3D(mean(obj.Coords, 1));
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
    
    function h = draw(varargin)
        % Draw the current geometry, eventually specifying the style
        
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
        hh = plot3(hAx, obj.Coords(:,1), obj.Coords(:,2), obj.Coords(:,3), options{:});

        % optionnally add style processing
        if ~isempty(varargin) && isa(varargin{1}, 'Style');
            apply(varargin{1}, hh);
        end
        
        % format output argument
        if nargout > 0
            h = hh;
        end
    end
    
    function res = scale(obj, varargin)
        % Returns a scaled version of this geometry
        factor = varargin{1};
        res = MultiPoint3D(obj.Coords * factor);
    end
    
    function res = translate(obj, varargin)
        % Returns a translated version of this geometry
        shift = varargin{1};
        res = MultiPoint3D(bsxfun(@plus, obj.Coords, shift));
    end
    
end % end methods


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'MultiPoint3D', 'coordinates', obj.Coords);
    end
end
methods (Static)
    function poly = fromStruct(str)
        % Create a new instance from a structure
        poly = MultiPoint3D(str.coordinates);
    end
end

end % end classdef

