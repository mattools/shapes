classdef AffineTransform3D < handle
%AFFINETRANSFORM2D A 3D affine transform defined by its matrix
%
%   Class AffineTransform3D
%
%   Example
%   AffineTransform3D
%
%   See also
%   AffineTransform2D

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-04-03,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % the inner matrix of this transform
    Matrix = eye(4);
    
end % end properties


%% Constructor
methods
    function obj = AffineTransform3D(mat)
    % Constructor for AffineTransform3D class
    
        if nargin < 1
            mat = eye(4);
        end
        if ~isnumeric(mat) || any(size(mat) ~= 4)
            error('requires a 3x3 matrix as input');
        end
    
        obj.Matrix = mat;
    end
    
end % end constructors


%% Methods
methods
end % end methods

end % end classdef

