function style = parseStyleFromJson(str)
%PARSESTYLEFROMJSON  One-line description here, please.
%
%   output = parseStyleFromJson(input)
%
%   Example
%   parseStyleFromJson
%
%   See also
%
 
% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - Cepia Software Platform.


if ~isstruct(str)
    error('Requires a structure as input');
end

% create default style
style = Style();

% check each filed to update current style
names = fieldnames(str);
for i = 1:length(names)
    name = names{i};
    
    if strcmp(name, 'markerColor')
        style.markerColor = str.(name);
    elseif strcmp(name, 'markerSize')
        style.markerSize = str.(name);
    elseif strcmp(name, 'markerStyle')
        style.markerStyle = str.(name);
    elseif strcmp(name, 'markerFillColor')
        style.markerFillColor = str.(name);
    elseif strcmp(name, 'markerVisible')
        style.markerVisible = str.(name);

    elseif strcmp(name, 'lineColor')
        style.lineColor = str.(name);
    elseif strcmp(name, 'lineWidth')
        style.lineWidth = str.(name);
    elseif strcmp(name, 'lineStyle')
        style.lineStyle = str.(name);
    elseif strcmp(name, 'lineVisible')
        style.lineVisible = str.(name);
        
    elseif strcmp(name, 'fillColor')
        style.fillColor = str.(name);
    elseif strcmp(name, 'fillOpacity')
        style.fillOpacity = str.(name);
    elseif strcmp(name, 'fillVisible')
        style.fillVisible = str.(name);
        
    else
        warning(['Unrecognized style option : ' name]);
    end
end