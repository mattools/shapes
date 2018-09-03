function str = formatStyleToJson(style)
%FORMATSTYLETOJSON  One-line description here, please.
%
%   output = formatStyleToJson(input)
%
%   Example
%   formatStyleToJson
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-02,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - Cepia Software Platform.

% check class validity
if ~isa(style, 'Style')
    error('Requires an instance of Style');
end

% convert to structure
str = struct();

str.markerColor = style.markerColor;
str.markerSize = style.markerSize;
str.markerStyle = style.markerStyle;
str.markerFillColor = style.markerFillColor;
str.markerVisible = style.markerVisible;

str.lineColor = style.lineColor;
str.lineWidth = style.lineWidth;
str.lineStyle = style.lineStyle;
str.lineVisible = style.lineVisible;

str.fillColor = style.fillColor;
str.fillOpacity = style.fillOpacity;
str.fillVisible = style.fillVisible;
