%DEMO_SHAPES_KANDINSKY  One-line description here, please.
%
%   output = demo_shapes_kandinsky(input)
%
%   Example
%   demo_shapes_kandinsky
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.


%% Create a display the scene

L = 10;

baseLength = sqrt(5)/2 * 20;
tri = Polygon2D([20-baseLength/2 10; 20+baseLength/2 10; 20 30]);
triStyle = Style('fillColor', 'y', 'fillVisible', true, 'lineWidth', 2, 'lineColor', 'k');
triShape = Shape(tri, triStyle);

square = Polygon2D([35 10; 55 10; 55 30;35 30]);
squareStyle = Style('fillColor', 'r', 'fillVisible', true, 'lineWidth', 2, 'lineColor', 'k');
squareShape = Shape(square, squareStyle);

circ = Polygon2D(circleToPolygon([70 20 10], 60));
circStyle = Style('fillColor', 'b', 'fillVisible', true, 'lineWidth', 2, 'lineColor', 'k');
circShape = Shape(circ, circStyle);

scene = Scene;
addShape(scene, triShape);
addShape(scene, squareShape);
addShape(scene, circShape);
scene.viewBox = [0 90 0 50];

draw(scene);


%% save the scene and re-open it

json = savejson('', toStruct(scene));

scene2 = Scene.fromStruct(loadjson(json));

draw(scene2);
