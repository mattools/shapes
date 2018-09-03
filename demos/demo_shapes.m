%DEMO_SHAPES  One-line description here, please.
%
%   output = demo_shapes(input)
%
%   Example
%   demo_shapes
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-08-14,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - Cepia Software Platform.

% create a polygon
verts = ellipseToPolygon([50 50 40 20 30]);
poly = Polygon2D(verts);

% dispy polygon
figure; hold on; 
draw(poly);
axis equal; axis([0 100 0 100]);
drawnow;

% draw bounding box
draw(boundingBox(poly), 'k')