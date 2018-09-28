classdef Scene < handle
%SCENE  A container of shape instances
%
%   Class Scene
%
%   Example
%   Scene
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-09-03,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    % the set of shapes within this scene. 
    % Stored as a struct array.
    shapes;
    
    % Description of x-axis, as a SceneAxis instance
    xAxis;
    
    % Description of y-axis, as a SceneAxis instance
    yAxis;
    
    % Description of z-axis, as a SceneAxis instance
    zAxis;

    % indicates whether main axes are visible or not (boolean)
    axisLinesVisible = true;
    
end % end properties


%% Constructor
methods
    function this = Scene(varargin)
        % Constructor for Scene class
        
        % create new axes
        this.xAxis = SceneAxis();
        this.yAxis = SceneAxis();
        this.zAxis = SceneAxis();
        
    end

end % end constructors


%% Display Methods
methods
    function varargout = draw(this)
        % display current scene in a new figure
        hFig = figure; 
        
        % setup axis
        axis equal; hold on;
        
        % set view box from axis limits stored within scene
        axis(viewBox(this));

        % draw lines for X and Y axes, based on current axis bounds
        if this.axisLinesVisible
            plot(this.xAxis.limits, [0 0], 'k-');
            plot([0 0], this.yAxis.limits, 'k-');
        end

        for iShape = 1:length(this.shapes)
            draw(this.shapes(iShape));
        end
        
        if nargout > 0
            varargout = {hFig};
        end
    end
    
    function box = viewBox(this)
        % Compute the view box from the limits on the different axes
        box = [this.xAxis.limits this.yAxis.limits this.zAxis.limits];
    end
    
    function setViewBox(this, box)
        % set axes limits from viewbox values
        this.xAxis.limits = box(1:2);
        this.yAxis.limits = box(3:4);
        this.zAxis.limits = box(5:6);
    end
end % end methods

%% Shapes management

methods
    function addShape(this, s)
        % add a given shape to this scene
        this.shapes = [this.shapes s];
    end
    
    function removeShape(this, s)
        % remove a given shape from this scene
        ind = [];
        for i = 1:length(this.shapes)
            if this.shapes(i) == s
                ind = i;
                break;
            end
        end
        if isempty(ind)
            disp('could not find shape to remove');
            return;
        end
        this.shapes(ind) = [];
    end
    
    function shapes = getShapes(this)
        % return a cell array containing the shapes in this scene
        shapes = this.shapes;
    end
    
    function clearShapes(this)
        % clear the shapes within this scene
        this.shapes = {};
    end
    
end

%% Serialization methods
methods
    function str = toStruct(this)
        % Convert to a structure to facilitate serialization

        % first add information about axes
        str.xAxis = toStruct(this.xAxis);
        str.yAxis = toStruct(this.yAxis);
        str.zAxis = toStruct(this.zAxis);

        % create a structure for the list of shapes
        str.shapes = cell(1, length(this.shapes));
        for i = 1:length(this.shapes)
            str.shapes{i} = toStruct(this.shapes(i));
        end
        
        str.axisLinesVisible = this.axisLinesVisible;
        
    end
    
    function write(this, fileName, varargin)
        % Write into a JSON file
        savejson('', toStruct(this), 'FileName', fileName, varargin{:});
    end
end
methods (Static)
    function scene = fromStruct(str)
        % Create a new instance from a structure
        
        % create an empty scene
        scene = Scene();
        
        % parse eventual axes information
        if isfield(str, 'xAxis')
            scene.xAxis = SceneAxis.fromStruct(str.xAxis);
        end
        if isfield(str, 'yAxis')
            scene.yAxis = SceneAxis.fromStruct(str.yAxis);
        end
        if isfield(str, 'zAxis')
            scene.zAxis = SceneAxis.fromStruct(str.zAxis);
        end
        
        % parse list of shapes
        shapeList = str.shapes;
        for iShape = 1:length(shapeList)
            shape = Shape.fromStruct(shapeList{iShape});
            addShape(scene, shape);
        end

        if isfield(str, 'axisLinesVisible')
            scene.axisLinesVisible = str.axisLinesVisible;
        end
    end
    
    function scene = read(fileName)
        % Read a scene from a file in JSON format
        scene = Scene.fromStruct(loadjson(fileName));
    end
end

end % end classdef

