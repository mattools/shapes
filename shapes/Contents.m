% SHAPES
%
% Geometry classes (global)
%   Geometry             - Abstract class for a geometry of any dimensionality.
%
% Geometry classes for 2D
%   Geometry2D           - Abstract class for planar geometries.
%   Point2D              - A point in the 2-dimensional plane.
%   MultiPoint2D         - A set of points in the plane.
%   Box2D                - Bounding box of a planar shape.
%   AffineTransform2D    - A 2D affine transform defined by its matrix.
%   LineString2D         - An open polyline composed of several line segments. 
%   LinearRing2D         - A closed polyline in the plane.
%   Polygon2D            - A polygon in the plane.
%   Circle2D             - A circle in the plane.
%   Ellipse2D            - A planar ellipse.
%   Patch2D              - A 2D parametric grid defined by two arrays x and y.
%
% Geometry classes for 3D
%   Geometry3D           - Abstract class for 3D geometries.
%   Point3D              - A point in the 3-dimensional space.
%   MultiPoint3D         - A set of points in the 3D space.
%   Box3D                - Bounding box of a 3D shape.
%   AffineTransform3D    - A 3D affine transform defined by its matrix.
%   LineString3D         - An open 3D polyline composed of several line segments.
%   Meshes3D             - Utility class containing static methods for meshes.
%   TriMesh3D            - Class for representing a 3D triangular mesh.
%   Patch3D              - A 3D parametric surface defined by three arrays x, y, and z.
%
% Scene graph managment
%   Scene                - A container of shape instances.
%   SceneAxis            - Describes one of the axes of a scene.
%   SceneGraph           - The top-level class for the scene.
%   SceneNode            - Abstract class for Node in a SceneGraph.
%   GroupNode            - Contatenates a group of nodes.
%   ImageNode            - Contains information to represent an image within the scene.
%   Shape                - Contains information to draw a 2D or 3D shape.
%   ShapeNode            - Contains information to draw a 2D or 3D shape.
%   Style                - Encapsulates information for drawing shapes.
%   TransformedImageNode - A transform applied to an image.
%   TransformNode        - Apply a transform to another node.



