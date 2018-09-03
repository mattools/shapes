classdef Shape < handle
%SHAPE Contains information to draw a 2D or 3D shape 
%
%   The shape class ezncapsulates information about the geometry of the
%   shape (as an instance of Geometry class) and drawing options (as an
%   instance of the Style class).
%
%   Example
%   Shape
%
%   See also
%     Geometry2D, Geometry2D, Style

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-08-13,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    geometry;
    
    style;
    
    visible = true;
    
    name = '';
    
end % end properties


%% Constructor
methods
    function this = Shape(varargin)
    % Constructor for Shape class

        if nargin == 1
            this.geometry = varargin{1};
            this.style = Style();
            
        elseif nargin == 2
            this.geometry = varargin{1};
            this.style = varargin{2};
            
        else
            error('Wrong number of arguments for creation of Shape');
        end
    end

end % end constructors


%% Methods
methods
    function varargout = draw(this)
        h = draw(this.geometry, this.style);
        if nargout > 0
            varargout = {h};
        end
    end
end % end methods

end % end classdef

