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
    vertexCoords;
    
    % vertex indices for each face, as a NF-by-3 array
    faceVertexInds;
end

%% Constructor
methods
    function this = TriMesh3D(varargin)
        
        if isnumeric(varargin{1})
            this.vertexCoords = varargin{1};
            this.faceVertexInds = varargin{2};
            
        elseif isstruct(varargin{1})
            var1 = varargin{1};
            this.vertexCoords = var1.vertices;
            this.faceVertexInds = var1.faces;
        end
        
    end
end

%% Vertex management methods
methods
    function nv = vertexNumber(this)
        nv = size(this.vertexCoords, 1);
    end
    
    function verts = vertices(this)
        verts = this.vertexCoords;
    end
end

%% Face management methods
methods
    function nf = faceNumber(this)
        nf = size(this.faceVertexInds, 1);
    end
end


%% Methods implementing Geometry3D
methods
    function box = boundingBox(this)
        % Returns the bounding box of this shape
        mini = min(this.vertexCoords);
        maxi = max(this.vertexCoords);
        box = Box3D([mini(1) maxi(1) mini(2) maxi(2) mini(3) maxi(3)]);
    end
    
    function varargout = draw(this, varargin)
        % Draw the current geometry, eventually specifying the style
        
        h = drawMesh(this.vertexCoords, this.faceVertexInds);
        if nargin > 1
            var1 = varargin{1};
            if isa(var1, 'Style')
                apply(var1, h);
            end
        end
        
        if nargout > 0
            varargout = {h};
        end
    end
    
    function res = scale(this, varargin)
        % Returns a scaled version of this geometry
        factor = varargin{1};
        res = TriMesh3D(this.vertexCoords * factor, this.faceVertexInds);
    end
    
    function res = translate(this, varargin)
        % Returns a translated version of this geometry
        shift = varargin{1};
        res = TriMesh3D(bsxfun(@plus, this.vertexCords, shift), this.faceVertexInds);
    end
    
end % end methods


%% Serialization methods
methods
    function str = toStruct(this)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'TriMesh3D', ...
            'vertices', this.vertexCoords, ...
            'faces', this.faceVertexInds);
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