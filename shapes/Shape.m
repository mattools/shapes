classdef Shape < handle
%SHAPE  One-line description here, please.
%
%   Class Shape
%
%   Example
%   Shape
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2018-08-13,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    geometry;
    
    drawOptions;
    
    visible = true;
    
    name = '';
    
end % end properties


%% Constructor
methods
    function this = Shape(varargin)
    % Constructor for Shape class

        if nargin == 1
            this.geometry = varargin{1};
        else
            error('Only one argument is expected');
        end
        
        this.drawOptions = DrawOptions();
    end

end % end constructors


%% Methods
methods
    function h = draw(this, varargin)
        % draw the shape 
        
        geom = this.geometry;
        options = varargin;
%         options = [shape.drawOptions varargin];
        switch lower(geom.type)
            case 'point'
                h = drawPoint(geom.data, options{:});
                
            case 'polygon'
                h = drawPolygon(geom.data, options{:});
                
            case {'polyline', 'curve'}
                h = drawPolyline(geom.data, options{:});
                
            case 'circle'
                h = drawCircle(geom.data, options{:});
                
            case 'ellipse'
                h = drawEllipse(geom.data, options{:});
                
            case 'orientedbox'
                h = drawOrientedBox(geom.data, options{:});
                
            otherwise
                error(['Unknown shape type: ' shape.type]);
        end
    end
    
end % end methods

end % end classdef

