classdef AffineTransform2D < handle
%AFFINETRANSFORM2D A 2D affine transform defined by its matrix
%
%   Class AffineTransform2D
%
%   Example
%   AffineTransform2D
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-04-03,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % the inner matrix of this transform
    Matrix = eye(3);
    
end % end properties


%% Constructor
methods
    function obj = AffineTransform2D(mat)
    % Constructor for AffineTransform2D class
    
        if nargin < 1
            mat = eye(3);
        end
        if ~isnumeric(mat) || any(size(mat) ~= 3)
            error('requires a 3x3 matrix as input');
        end
    
        obj.Matrix = mat;
    end
    
end % end constructors


%% Methods
methods
end % end methods

end % end classdef

