classdef Geometry2D < Geometry
%Geometry2D Abstract class for planar geometries
%
%   Class Geometry2D
%
%   Example
%   Geometry2D
%
%   See also
%   svui.app.Polygon2d, svui.app.PointSet2d

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2014-08-14,    using Matlab 7.9.0.529 (R2009b)
% Copyright 2013 INRA - Cepia Software Platform.

%% Constructor
methods
    function this = Geometry2D(varargin)
    % Constructor for Geometry2D class
    %   (will be called by subclasses)

    end

end % end constructors


%% Abstract Methods
% Declares some methods that will be implemented by subclasses.
methods ( Abstract )
    
    box = boundingBox(this)
    % Returns the bounding box of this shape
    
    varargout = draw(this, varargin)
    % Draw the current geometry, eventually specifying the style
       
    res = scale(this, varargin)
    % Returns a scaled version of this geometry
        
    res = translate(this, varargin)
    % Returns a translated version of this geometry       
    
    res = rotate(this, varargin)
    % Returns a rotated version of this geometry
        
end % end methods

end % end classdef

