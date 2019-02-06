classdef Geometry3D < Geometry
%GEOMETRY3D Abstract class for 3D geometries
%
%   Class Geometry3D
%
%   Example
%   Geometry3D
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-02-06,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function this = Geometry3D(varargin)
    % Constructor for Geometry3D class
    %   (will be called by subclasses)

    end

end % end constructors


%% Abstract Methods
% Declares some methods that will be implemented by subclasses.
methods ( Abstract )
    
    box = boundingBox(this)
    % Returns the 3D bounding box of this geometry
    
    varargout = draw(this, varargin)
    % Draw the current geometry, eventually specifying the style
end

%% Abstract Methods
% Not sure we will keep these methods...
methods ( Abstract )
    
    res = scale(this, varargin)
    % Returns a scaled version of this geometry
        
    res = translate(this, varargin)
    % Returns a translated version of this geometry       
    
end % end methods


end % end classdef

