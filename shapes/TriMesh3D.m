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
    Vertices;
    
    % vertex indices for each edge, as a NE-by-2 array
    % Can be empty.
    Edges = [];
    
    % vertex indices for each face, as a NF-by-3 array
    Faces;
end

%% Constructor
methods
    function obj = TriMesh3D(varargin)
        
        if isnumeric(varargin{1})
            obj.Vertices = varargin{1};
            obj.Faces = varargin{2};
            
        elseif isstruct(varargin{1})
            var1 = varargin{1};
            obj.Vertices = var1.vertices;
            obj.Faces = var1.faces;
        end
        
    end
end

%% Drawing functions
methods
    function h = drawFaceNormals(obj, varargin)
        % h = drawFaceNormals(mesh);
        pts = faceCentroids(obj);
        pos = pts.Coords;
        vn = faceNormals(obj);
        h = quiver3(pos(:, 1), pos(:, 2), pos(:, 3), ...
            vn(:, 1), vn(:, 2), vn(:, 3), 0, varargin{:});
    end
end

%% Geometric information about mesh
methods
    function vol = volume(obj)
        % (signed) volume enclosed by this mesh
        %
        % See Also
        %   surfaceArea

        % initialize an array of volume
        nFaces = size(obj.Faces, 1);
        vols = zeros(nFaces, 1);

        % Shift all vertices to the mesh centroid
        centroid = mean(obj.Vertices, 1);
        
        % compute volume of each tetraedron
        for iFace = 1:nFaces
            % consider the tetrahedron formed by face and mesh centroid
            tetra = obj.Vertices(obj.Faces(iFace, :), :);
            tetra = bsxfun(@minus, tetra, centroid);
            
            % volume of current tetrahedron
            vols(iFace) = det(tetra) / 6;
        end
        
        vol = sum(vols);
    end
    
    function area = surfaceArea(obj)
        % surface area of mesh faces
        %
        % See Also
        %   volume
        
        % compute two direction vectors of each trinagular face, using the
        % first vertex of each face as origin
        v1 = obj.Vertices(obj.Faces(:, 2), :) - obj.Vertices(obj.Faces(:, 1), :);
        v2 = obj.Vertices(obj.Faces(:, 3), :) - obj.Vertices(obj.Faces(:, 1), :);
        
        % area of each triangle is half the cross product norm
        % see also crossProduct3d in MatGeom
        vn = zeros(size(v1));
        vn(:) = bsxfun(@times, v1(:,[2 3 1],:), v2(:,[3 1 2],:)) - ...
                bsxfun(@times, v2(:,[2 3 1],:), v1(:,[3 1 2],:));
        vn = sqrt(sum(vn .* vn, 2));
        
        % sum up and normalize
        area = sum(vn) / 2;
    end
    
%     function mb = meanBreadth(obj)
%         % Mean breadth of this mesh
%         % Mean breadth is proportionnal to the integral of mean curvature
%         %
%         % See Also
%         %   trimeshMeanBreadth
%         
%         mb = trimeshMeanBreadth(obj.Vertices, obj.Faces);
%     end
end


%% Vertex management methods
methods
    function nv = vertexNumber(obj)
        nv = size(obj.Vertices, 1);
    end
    
    function verts = vertices(obj)
        verts = MultiPoint3D(obj.Vertices);
    end
end

%% Edge management methods
methods
    function ne = edgeNumber(obj)
        % ne = edgeNumber(mesh)
        computeEdges(obj);
        ne = size(obj.Edges, 1);
    end
        
    function edgeList = edges(obj)
        % edgeList = edges(mesh);
        if isempty(obj.Edges)
            computeEdges(obj);
        end
        edgeList = obj.Edges;
    end
end

methods (Access = private)
    function computeEdges(obj)
        % updates the property Edges
        
        % compute total number of edges
        % (3 edges per face)
        nFaces  = size(obj.Faces, 1);
        nEdges  = nFaces * 3;
        
        % create vertex indices for all edges (including duplicates)
        edges = zeros(nEdges, 2);
        for i = 1:nFaces
            f = obj.Faces(i, :);
            edges(((i-1)*3+1):i*3, :) = [f' f([2:end 1])'];
        end
        
        % remove duplicate edges, and sort the result
        obj.Edges = sortrows(unique(sort(edges, 2), 'rows'));
    end
end

%% Face management methods
methods
    function nf = faceNumber(obj)
        nf = size(obj.Faces, 1);
    end
    
    function normals = faceNormals(obj, inds)
        % vn = faceNormals(mesh);
        
        nf = size(obj.Faces, 1);
        if nargin == 1
            inds = 1:nf;
        end

        % compute vector of each edge
        v1 = obj.Vertices(obj.Faces(inds,2),:) - obj.Vertices(obj.Faces(inds,1),:);
        v2 = obj.Vertices(obj.Faces(inds,3),:) - obj.Vertices(obj.Faces(inds,1),:);

        % compute normals using cross product (vectors have same size)
        normals = cross(v1, v2, 2);
    end
    
    function pts = faceCentroids(obj, inds)
        % pts = faceCentroids(mesh);
        nf = size(obj.Faces, 1);
        if nargin == 1
            inds = 1:nf;
        end
        pts = zeros(length(inds), 3);
        
        for i = 1:3
            pts = pts + obj.Vertices(obj.Faces(inds,i),:) / 3;
        end
        
        pts = MultiPoint3D(pts);
    end

    function poly = facePolygon(obj, ind)
        poly = obj.Vertices(obj.Faces(ind, :), :);
    end
end


%% Methods implementing Geometry3D
methods
    function box = boundingBox(obj)
        % Returns the bounding box of this shape
        mini = min(obj.Vertices);
        maxi = max(obj.Vertices);
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
            'vertices', obj.Vertices, 'faces', obj.Faces, ...
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
        res = TriMesh3D(obj.Vertices * factor, obj.Faces);
    end
    
    function res = translate(obj, varargin)
        % Returns a translated version of this geometry
        shift = varargin{1};
        res = TriMesh3D(bsxfun(@plus, obj.vertexCords, shift), obj.Faces);
    end
    
end % end methods


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization
        str = struct('type', 'TriMesh3D', ...
            'vertices', obj.Vertices, ...
            'faces', obj.Faces);
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