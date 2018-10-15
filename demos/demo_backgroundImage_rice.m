%ESSAI_BACKGROUNDIMAGE_RICE  One-line description here, please.
%
%   output = essai_backgroundImage_rice(input)
%
%   Example
%   essai_backgroundImage_rice
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-10-15,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2018 INRA - Cepia Software Platform.

% read data
img = imread('rice.png');

% image processing
img2 = imtophat(img, ones(30, 30));

% extract centroid coordiates of grains
bin = imopen(img2 > imOtsuThreshold(img2), ones(3,3));
lbl = bwlabel(bin, 4);
centroids = imCentroid(lbl);

% show result (classical method)
figure; imshow(img);
hold on; drawPoint(centroids, 'b+');

%% Create scene

% create scene
scene = Scene();

% setup background image
setBackgroundImage(scene, img);

% add centroid shape
shape = Shape(MultiPoint2D(centroids));
shape.style.lineWidth = 2;
shape.style.markerColor = 'm';
addShape(scene, shape);

% display result
draw(scene);