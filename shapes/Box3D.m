classdef Box3D < Geometry3D
%BOX3D Bounding box of a 3D shape
%
%   Class Box3D
%   Defined by max extent in each dimension:
%   * xmin, xmax, ymin, ymax, zmin, zmax
%
%   Example
%   box = Box3D([0, 10, 0, 10, 0, 10])
%
%   See also
%   Geometry3D, Box2D
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-02-06,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    xmin;
    xmax;
    ymin;
    ymax;
    zmin;
    zmax;

end % end properties


%% Constructor
methods
    function this = Box3D(varargin)
        % Constructor for Box3D class
        
        if ~isempty(varargin)
            var1 = varargin{1};
            if size(var1, 1) ~= 1
                error('Creating a box requires an array with one row, not %d', size(var1, 1));
            end
            if size(var1, 2) ~= 6
                error('Creating a box requires an array with six columns, not %d', size(var1, 2));
            end
            data = var1;
        else
            % default box is unit square, with origin as lower-left corner.
            data = [0 1 0 1 0 1];
        end
        
        this.xmin = data(1);
        this.xmax = data(2);
        this.ymin = data(3);
        this.ymax = data(4);
        this.zmin = data(5);
        this.zmax = data(6);

    end

end % end constructors


%% Methods
methods
    function box = boundingBox(this)
        % Returns the bounding box of this shape
        box = this.data;
    end
    
    function varargout = draw(this, varargin)
        % Draw the current geometry, eventually specifying the style
        
        % extract style agument if present
        style = [];
        if nargin > 1 && isa(varargin{1}, 'Style')
            style = varargin{1};
            varargin(1) = [];
        end
        
        % draw the box
        h = drawBox3d([this.xmin this.xmax this.ymin this.ymax this.zmin this.zmax], varargin{:});
        
        % eventually apply style
        if ~isempty(style)
            apply(style, h);
        end
        
        % return handle if requested
        if nargout > 0
            varargout = {h};
        end
    end
    
    function res = scale(this, varargin)
        % Returns a scaled version of this geometry
        factor = varargin{1};
        res = Box3D([this.xmin this.xmax this.ymin this.ymax this.zmin this.zmax] * factor);
    end
    
    function res = translate(this, varargin)
        % Returns a translated version of this geometry
        shift = varargin{1};
        data2 = [this.xmin this.xmax this.ymin this.ymax this.zmin this.zmax] + shift(1, [1 1 2 2 3 3]);
        res = Box3D(data2);
    end
end % end methods


%% Serialization methods
methods
    function str = toStruct(this)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'Box3D', ...
            'xmin', this.xmin, 'xmax', this.xmax, ...
            'ymin', this.ymin, 'ymax', this.ymax, ...
            'zmin', this.zmin, 'zmax', this.zmax);
    end
end
methods (Static)
    function box = fromStruct(str)
        % Create a new instance from a structure
        box = Box3D([str.xmin str.xmax str.ymin str.ymax str.zmin str.zmax]);
    end
end

end % end classdef

