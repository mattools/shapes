classdef TransformNode < handle
%TRANSFORMNODE  One-line description here, please.
%
%   Class TransformNode
%
%   Example
%   TransformNode
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
    % The node to transform, as a SceneNode instance
    Node;
    
    % The transform to apply, as a 3-by-3 matrix
    Transform;
    
end % end properties


%% Constructor
methods
    function obj = TransformNode(varargin)
    % Constructor for TransformNode class

        if nargin < 2
            error('Requires at least two input arguments');
        end
        
        var1 = varargin{1};
        if ~isa(var1, 'SceneNode')
            error('First argument must be a SceneNode');
        end
        obj.Node = var1;
        
        var2 = varargin{2};
        if ~isa(var2, 'AffineTransform2D') && ~isa(var2, 'AffineTransform3D') 
            error('Second argument must be an affine transform');
        end
        obj.Transform = var2;
        
    end

end % end constructors


%% Methods
methods
end % end methods

end % end classdef

