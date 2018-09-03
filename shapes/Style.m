classdef Style < handle
%STYLE Stores information for drawing shapes
%
%   Class Style
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
    markerColor     = [0 0 1];
    markerSize      = 6;
    markerStyle     = '+';
    markerFillColor = 'none';
    markerVisible   = false;
    
    lineColor       = 'b';
    lineWidth       = .5;
    lineStyle       = '-';
    lineVisible     = true;
    
    fillColor       = [0 1 1];
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
            copyFields(that);
            return;
        end
        
        while length(varargin) >= 2
            name = varargin{1};
            value = varargin{2};
            
            if strcmpi(name, 'markerColor')
                this.markerColor = value;
            elseif strcmpi(name, 'markerStyle')
                this.markerStyle = value;
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
        
        if this.markerVisible
            set(h, 'Marker',            this.markerStyle);
            set(h, 'MarkerEdgeColor',   this.markerColor);
            set(h, 'MarkerSize',        this.markerSize);
            set(h, 'MarkerFaceColor',   this.markerFillColor);            
        else
            set(h, 'Marker', 'none');
        end
        
        if this.lineVisible 
            set(h, 'LineStyle',         this.lineStyle);
            set(h, 'Color',             this.lineColor);
            set(h, 'LineWidth',         this.lineWidth);
        else
            set(h, 'LineStyle', 'none');
        end
        
        hType = get(h, 'Type');
        if strcmp(hType, 'patch') 
            if this.isFillVisible
                set(h, 'FaceColor', this.FillColor);
                set(h, 'FaceAlpha', this.FillOpacity);
            else
            end
        end
        
    end
    
end % end methods

end % end classdef
