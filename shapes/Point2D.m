classdef Point2D < Geometry2D
%POINT2D  One-line description here, please.
%
%   Class Point2D
%
%   Example
%   Point2D
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@nantes.inra.fr
% Created: 2018-09-01,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    coords = [0 0];
end % end properties


%% Constructor
methods
    function this = Point2D(varargin)
        % Constructor for Point2D class
        
        % empty constructor -> origin
        if isempty(varargin)
            return;
        end
        
        var1 = varargin{1};
        
        % copy constructor
        if isa(var1, 'Point2D')
            this.coords = var1.coords;
            return;
        end
        
        % parse numeric values
        if isnumerci(var1)
            if any(size(coords) ~= [1 2])
                error('Requires a 1-by-2 array of numerical values');
            end
            this.coords = var1;
        end
    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef

