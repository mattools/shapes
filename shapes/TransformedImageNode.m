classdef TransformedImageNode < handle
%TRANSFORMEDIMAGENODE A transform applied to an image
%
%   Class TransformedImageNode
%
%   Example
%     % create base image node
%     imageNode = ImageNode('cameraman.tif');
%     % compute a transform (rotation around center + translation)
%     tra0 = AffineTransform2D.createTranslation([128 128]);
%     rot = AffineTransform2D.createRotation(30 * pi / 180);
%     tra2 = AffineTransform2D.createTranslation([200 100]);
%     transfo = tra2 * tra0 * rot * invert(tra0);
%     % apply transform to the node
%     transfoNode = TransformedImageNode(imageNode, transfo);
%     % display original and transformed nodes
%     figure; hold on; draw(imageNode);
%     draw(transfoNode);
%
%   See also
%     SceneNode, ImageNode, AffineTransform2D

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-05-08,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % The image to transform, as an instance of ImageNode
    Node;
    
    % The transform to apply, as an instance of AffineTransform2D or 3D
    Transform;
end % end properties


%% Constructor
methods
    function obj = TransformedImageNode(varargin)
    % Constructor for TransformedImageNode class
    
        if nargin < 2
            error('requires at least two inpt arguments');
        end
        
        if ~isa(varargin{1}, 'ImageNode')
            error('requires an ImageNode as first input');
        end
        if ~isa(varargin{2}, 'AffineTransform2D') && ~isa(varargin{2}, 'AffineTransform3D')
            error('requires an AffineTransform2D or 3D as second input');
        end
       
        obj.Node = varargin{1};
        obj.Transform = varargin{2};

    end

end % end constructors


%% Methods
methods
end % end methods

%% Methods specializing the SceneNode superclass
methods
    function h = draw(obj, varargin)
        % display transformed image data on current axis
        
        extent = physicalExtent(obj.Node);
        
        % create the patch object for representing the image
        dims = obj.Node.ImageSize;
        lx = linspace(extent(1), extent(2), dims(1)+1);
        ly = linspace(extent(3), extent(4), dims(2)+1);
        [x, y] = meshgrid(lx, ly);
        patch = Patch3D(x, y, zeros(size(x)));
        
        % apply transform to patch
        patch = transform(patch, obj.Transform);
        
        % display patch
        data = imageData(obj.Node);
        data = padarray(data, [1 1], 'replicate', 'post');
        s = surf(gca, patch.X, patch.Y, patch.Z, data, 'linestyle', 'none');

%         % overlay grid
%         drawSubGrid(aPatch, 8, 'color', 'b');
%         corners = [...
%             extent(1) extent(3); ...
%             extent(1) extent(4); ...
%             extent(2) extent(4); ...
%             extent(2) extent(3)  ];
%         corners = transformCoords(obj.Transform, corners);
%         drawPolygon(corners, 'b');
        
        if nargout > 0
            h = s;
        end
    end
end

end % end classdef

