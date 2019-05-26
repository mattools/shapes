classdef TransformNode < SceneNode
%TRANSFORMNODE Apply a transform to another node
%
%   Class TransformNode
%   NODE2 = TransformNode(NODE, TRANSFO);
%   NODE is an instance of SceneNode
%   TRANDFO is an instance of AffineTransform2D or AffineTransform3D
%
%   Example
%   TransformNode
%
%   See also
%     SceneNode, AffineTransform2D, AffineTransform3D

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-04-03,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % The node to transform, as a SceneNode instance
    Node;
    
    % The transform to apply, as an instance of AffineTransform2D or 3D
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
    function varargout = draw(obj)
        % Transforms and draws the child node
        tnode = transform(obj.Node, obj.Transform);
        h = draw(tnode);
        if nargout > 0
            varargout = {h};
        end
    end
    
    
    function box = boundingBox(obj)
        % Returns the bounding box of this node, as a 1-by-6 row vector
        box = boundingBox(transform(obj.Node, obj.Transform));
    end
    
    function printTree(obj, nIndents)
        str = [repmat('  ', 1, nIndents) '[TransformNode]'];
        disp(str);
        printTree(obj.Node, nIndents+1);       
%         % print transform string
%         str = [repmat('  ', 1, nIndents+1) 'Transform='];
%         disp(str);
    end
    
    function b = isLeaf(obj) %#ok<MANU>
        % returns false
        b = false;
    end
    
end % end methods

end % end classdef

