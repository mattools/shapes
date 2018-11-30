classdef Style < handle
%STYLE Stores information for drawing shapes
%
%   Class Style
%   Contains the information for drawing a shape.
%
%   The different fields in Style are:
%     markerColor     = 'b';
%     markerStyle     = '+';
%     markerSize      = 6;
%     markerFillColor = 'none';
%     markerVisible   = false;
%     lineColor       = 'b';
%     lineWidth       = .5;
%     lineStyle       = '-';
%     lineVisible     = true;
%     fillColor       = 'y';
%     fillOpacity     = 1;
%     fillVisible     = false;
%
%
%   Example
%     % draw a polygon with default style
%     poly = [10 10;20 10;20 20;10 20];
%     figure; h1 = drawPolygon(poly, 'b');
%     axis equal; axis([0 50 0 50]);
%     % change style using Style class
%     style1 = Style('lineWidth', 2, 'lineColor', 'g');
%     apply(style1, h1)
%     % chage vertex style
%     hold on;
%     h2 = drawPolygon(poly);
%     style2 = Style('markerStyle', 's', 'MarkerColor', 'k', 'MarkerFillColor', 'w', 'MarkerVisible', true, 'LineVisible', false);
%     apply(style2, h2)
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-01,    using Matlab 8.6.0.267246 (R2015b)
% Copyright 2018 INRA - BIA-BIBS.



%% Properties
properties
    markerColor     = 'b';
    markerStyle     = '+';
    markerSize      = 6;
    markerFillColor = 'none';
    markerVisible   = false;
    
    lineColor       = 'b';
    lineWidth       = .5;
    lineStyle       = '-';
    lineVisible     = true;
    
    fillColor       = 'y';
    fillOpacity     = 1;
    fillVisible     = false;
    
end % end properties


%% Constructor
methods
    function this = Style(varargin)
    % Constructor for Style class

        if nargin == 0
            return;
        end
        
        var1 = varargin{1};
        if isa(var1, 'Style')
            copyFields(var1);
            return;
        end
        
        while length(varargin) >= 2
            name = varargin{1};
            value = varargin{2};
            
            if strcmpi(name, 'markerColor')
                this.markerColor = value;
            elseif strcmpi(name, 'markerStyle')
                this.markerStyle = value;
            elseif strcmpi(name, 'markerSize')
                this.markerSize = value;
            elseif strcmpi(name, 'markerFillColor')
                this.markerFillColor = value;
            elseif strcmpi(name, 'markerVisible')
                this.markerVisible= value;
                
            elseif strcmpi(name, 'lineColor')
                this.lineColor = value;
            elseif strcmpi(name, 'lineWidth')
                this.lineWidth = value;
            elseif strcmpi(name, 'lineStyle')
                this.lineStyle = value;
            elseif strcmpi(name, 'lineVisible')
                this.lineVisible= value;
                
            elseif strcmpi(name, 'fillColor')
                this.fillColor = value;
            elseif strcmpi(name, 'fillOpacity')
                this.fillOpacity = value;
            elseif strcmpi(name, 'fillVisible')
                this.fillVisible= value;
            end
            
            varargin(1:2) = [];
        end
        
        function copyFields(that)
            this.markerColor        = that.markerColor;
            this.markerStyle        = that.markerStyle;
            this.markerSize         = that.markerSize;
            this.markerFillColor    = that.markerFillColor;
            this.markerVisible      = that.markerVisible;
            
            this.lineColor          = that.lineColor;
            this.lineWidth          = that.lineWidth;
            this.lineStyle          = that.lineStyle;
            this.lineVisible        = that.lineVisible;
            
            this.fillColor          = that.fillColor;
            this.fillOpacity        = that.fillOpacity;
            this.fillVisible        = that.fillVisible;

        end
    end

end % end constructors


%% Methods
methods
    function apply(this, h)
        % apply the style to the given graphic handle(s)
        
        hType = get(h, 'Type');

        if this.markerVisible && ~strcmp(hType, 'patch')
            set(h, 'MarkerEdgeColor',   this.markerColor);
            set(h, 'Marker',            this.markerStyle);
            set(h, 'MarkerSize',        this.markerSize);
            set(h, 'MarkerFaceColor',   this.markerFillColor);            
            set(h, 'LineWidth',         this.lineWidth);
        else
            set(h, 'Marker', 'none');
        end
        
        if this.lineVisible && ~strcmp(hType, 'patch')
            set(h, 'LineStyle',         this.lineStyle);
            set(h, 'Color',             this.lineColor);
            set(h, 'LineWidth',         this.lineWidth);
        else
            set(h, 'LineStyle', 'none');
        end
        
        if this.fillVisible && strcmp(hType, 'patch')
            set(h, 'FaceColor', this.fillColor);
            set(h, 'FaceAlpha', this.fillOpacity);
        end
    end
    
end % end methods

%% Serialization methods
methods
    function str = toStruct(this)
        % Convert to a structure to facilitate serialization

        % create empty struct
        str = struct();
        
        % update marker modifiers with values different from default
        if this.markerColor ~= 'b'
            str.markerColor = this.markerColor;
        end
        if this.markerStyle ~= '+'
            str.markerStyle = this.markerStyle;
        end
        if this.markerSize ~= 6
            str.markerSize = this.markerSize;
        end
        if ~ischar(this.markerFillColor) || ~strcmp(this.markerFillColor, 'none')
            str.markerFillColor = this.markerFillColor;
        end
        if this.markerVisible ~= false
            str.markerVisible = this.markerVisible;
        end
        
        % update line modifiers with values different from default
        if this.lineColor ~= 'b'
            str.lineColor = this.lineColor;
        end
        if this.lineWidth ~= .5
            str.lineWidth = this.lineWidth;
        end
        if ~strcmp(this.lineStyle, '-')
            str.lineStyle = this.lineStyle;
        end
        if this.lineVisible ~= true
            str.lineVisible = this.lineVisible;
        end
        
        % update fill modifiers with values different from default
        if this.fillColor ~= 'y'
            str.fillColor = this.fillColor;
        end
        if this.fillOpacity ~= 1
            str.fillOpacity = this.fillOpacity;
        end
        if this.fillVisible ~= false
            str.fillVisible = this.fillVisible;
        end
    end
    
    function write(this, fileName, varargin)
        % Write into a JSON file
        savejson('', toStruct(this), 'FileName', fileName, varargin{:});
    end
end

methods (Static)
    function style = fromStruct(str)
        % Create a new instance from a structure
        
        % create default empty style
        style = Style();
        mc = metaclass(style);
        
        % update styles with fields
        names = fieldnames(str);
        for i = 1:length(names)
            name = names{i};
            if ~isempty(findobj(mc.PropertyList, 'Name', name))
                style.(name) = str.(name);
            else
                error(['Unknown style modifier: ' name]);
            end
        end
    end
    
    function style = read(fileName)
        % Read a style from a file in JSON format
        style = Style.fromStruct(loadjson(fileName));
    end
end

end % end classdef
