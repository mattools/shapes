classdef Box2D < Geometry2D
%BOX2D Bounding box of a planar shape
%
%   Class Box2D
%   Dezfined by max extent in each dimension:
%   * xmin, xmax, ymin, ymax.
%
%   Example
%   box = Box2D([0, 10, 0, 10])
%
%   See also
%   Geometry2D

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-08-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.


%% Properties
properties
    xmin;
    xmax;
    ymin;
    ymax;
    
end % end properties


%% Constructor
methods
    function this = Box2D(varargin)
    % Constructor for Box2D class
    
        if ~isempty(varargin)
            var1 = varargin{1};
            if size(var1, 1) ~= 1
                error('Creating a box requires an array one row, not %d', size(var1, 1));
            end
            if size(var1, 2) ~= 4
                error('Creating a box requires an array with four columns, not %d', size(var1, 2));
            end
            data = var1;
        else
            % default box is unit square, with origin as lower-left corner.
            data = [0 1 0 1];
        end
        
        this.xmin = data(1);
        this.xmax = data(2);
        this.ymin = data(3);
        this.ymax = data(4);

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
        h = drawBox([this.xmin this.xmax this.ymin this.ymax], varargin{:});
        
        % eventually apply style
        if ~isempty(style)
            apply(var1, h);
        end
        
        % return handle if requested
        if nargout > 0
            varargout = {h};
        end
    end
    
    function res = scale(this, varargin)
        % Returns a scaled version of this geometry
        factor = varargin{1};
        res = Box2D([this.xmin this.xmax this.ymin this.ymax] * factor);
    end
    
    function res = translate(this, varargin)
        % Returns a translated version of this geometry
        shift = varargin{1};
        data2 = [this.xmin this.xmax this.ymin this.ymax] + shift(1, [1 1 2 2]);
        res = Box2D(data2);
    end
    
    function res = rotate(this, angle) %#ok<STOUT,INUSD>
        % Throws an error as a box can not be rotated
        error('A box can not be rotated');
    end
end % end methods

end % end classdef

