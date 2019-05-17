classdef TriMesh3D < Geometry3D
%TRIMESH Class for representing a triangular 3D mesh
%
%   output = TriMesh3D(input)
%
%   Example
%   TriMesh3D
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-02-07,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.

properties
    % coordinates of vertices, as a NV-by-3 array
    VertexCoords;
    
    % vertex indices for each face, as a NF-by-3 array
    FaceVertexInds;
end

%% Constructor
methods
    function obj = TriMesh3D(varargin)
        
        if isnumeric(varargin{1})
            obj.VertexCoords = varargin{1};
            obj.FaceVertexInds = varargin{2};
            
        elseif isstruct(varargin{1})
            var1 = varargin{1};
            obj.VertexCoords = var1.vertices;
            obj.FaceVertexInds = var1.faces;
        end
        
    end
end


%% Vertex management methods
methods
    function nv = vertexNumber(obj)
        nv = size(obj.VertexCoords, 1);
    end
    
    function verts = vertices(obj)
        verts = obj.VertexCoords;
    end
end

%% Face management methods
methods
    function nf = faceNumber(obj)
        nf = size(obj.FaceVertexInds, 1);
    end
end


%% Methods implementing Geometry3D
methods
    function box = boundingBox(obj)
        % Returns the bounding box of this shape
        mini = min(obj.VertexCoords);
        maxi = max(obj.VertexCoords);
        box = Box3D([mini(1) maxi(1) mini(2) maxi(2) mini(3) maxi(3)]);
    end
    
    function h = draw(varargin)
        % Draw the current geometry, eventually specifying the style
        
        % extract handle of axis to draw in
        if numel(varargin{1}) == 1 && ishghandle(varargin{1}, 'axes')
            hAx = varargin{1};
            varargin(1) = [];
        else
            hAx = gca;
        end

        % extract the point instance from the list of input arguments
        obj = varargin{1};
        varargin(1) = [];
        
        % add default drawing options
        options = {'FaceColor', [.7 .7 .7]};

        % extract optional drawing options
        if nargin > 1 && ischar(varargin{1})
            options = [options varargin];
        end
        
        if length(options) == 1
            options = [{'facecolor', [1 1 1]} options];
        end

        h = patch('Parent', hAx, ...
            'vertices', obj.VertexCoords, 'faces', obj.FaceVertexInds, ...
            options{:} );

        % optionnally add style processing
        if ~isempty(varargin) && isa(varargin{1}, 'Style')
            apply(varargin{1}, hh);
        end
                
        if nargout > 0
            h = hh;
        end
    end
    
    function res = scale(obj, varargin)
        % Returns a scaled version of this geometry
        factor = varargin{1};
        res = TriMesh3D(obj.VertexCoords * factor, obj.FaceVertexInds);
    end
    
    function res = translate(obj, varargin)
        % Returns a translated version of this geometry
        shift = varargin{1};
        res = TriMesh3D(bsxfun(@plus, obj.vertexCords, shift), obj.FaceVertexInds);
    end
    
end % end methods


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'TriMesh3D', ...
            'vertices', obj.VertexCoords, ...
            'faces', obj.FaceVertexInds);
    end
end
methods (Static)
    function mesh = fromStruct(str)
        % Create a new instance from a structure
        if ~(isfield(str, 'vertices') && isfield(str, 'faces'))
            error('Requires fields vertices and faces');
        end
        if size(str.faces, 2) ~= 3
            error('Requires a triangular face array');
        end
        mesh = TriMesh3D(str);
    end
end

end