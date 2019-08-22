classdef SceneGraph < handle
% The top-level class for the scene.
%
%   Class SceneGraph
%
%   Example
%   Scene
%
%   See also
%     SceneNode, ShapeNode
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-04-01,    using Matlab 9.4.0.813654 (R2018a)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    % the reference node of this scene graph, as a SceneNode instance.
    % Most of the time, this will be a GroupNode instance.
    RootNode;
    
    % Description of x-axis, as a SceneAxis instance
    XAxis;
    
    % Description of y-axis, as a SceneAxis instance
    YAxis;
    
    % Description of z-axis, as a SceneAxis instance
    ZAxis;

%     % an optional background image, as an instance of ImageNode (deprecated)
%     BackgroundImage;
    
    % indicates whether main axes are visible or not (boolean)
    AxisLinesVisible = true;
    
    % base directory for saving data
    BaseDir = pwd;
    
end % end properties


%% Constructor
methods
    function obj = SceneGraph(varargin)
        % Constructor for SceneGraph class
        
        % create new axes
        obj.XAxis = SceneAxis();
        obj.YAxis = SceneAxis();
        obj.ZAxis = SceneAxis();
        
        obj.BaseDir = pwd;
    end

end % end constructors


%% Operators on scenes
methods
    function res = merge(obj, that)
        % Merge the content of two scenes
        
        % copy all fields of first scene
        res = Scene();
        res.XAxis = SceneAxis(obj.XAxis);
        res.YAxis = SceneAxis(obj.YAxis);
        res.ZAxis = SceneAxis(obj.ZAxis);
        res.BackgroundImage = ImageNode(obj.BackgroundImage);
        res.AxisLinesVisible = obj.AxisLinesVisible;
        
        root = obj.RootNode;
        if ~isa(root, 'GroupNode')
            root = GroupNode();
            add(root, obj.RootNode);
        end
        
        if isa(that.RootNode, 'GroupNode')
            for iChild = 1:length(that.RootNode.Children)
                add(root, that.RootNode.Children(iChild));
            end
        else
            add(root, that.RootNode);
        end
    end
end

%% Display Methods
methods
    function varargout = draw(obj)
        % display current scene in a new figure
        
        % create new figure and keep handle to axis
        hFig = figure; 
        ax = gca;
        
        % setup axis
        axis equal; 
        hold on;
        
        % set view box from axis limits stored within scene
        box = viewBox(obj);
        if length(box) < 5 || box(5) == box(6)
            axis(box(1:4));
        else
            axis(box);
        end
        
        % optionnally reverse some axes
        if obj.XAxis.Reverse
            set(ax, 'xdir', 'reverse');
        end
        if obj.YAxis.Reverse
            set(ax, 'ydir', 'reverse');
        end
        if obj.ZAxis.Reverse
            set(ax, 'zdir', 'reverse');
        end
        
        % draw lines for X and Y axes, based on current axis bounds
        if obj.AxisLinesVisible
            plot(ax, obj.XAxis.Limits, [0 0], 'k-');
            plot(ax, [0 0], obj.YAxis.Limits, 'k-');
        end

        if ~isempty(obj.RootNode)
            draw(obj.RootNode);
        end
        
        if nargout > 0
            varargout = {hFig};
        end
    end
    
    function fitBoundsToShape(obj)
        % updates the bounds of the axis such that they contain all Shapes
        % (with finite geometries)

        % initial box
        box = [inf -inf inf -inf inf -inf];
        
        % avoid case with no shape
        if ~isempty(obj.RootNode)
            box = boundingBox(obj.RootNode);
        end
        
        if any(~isfinite(box(5:6)))
            box(5:6) = obj.ZAxis.Limits;
        end
        
        % set up new bounding box
        obj.XAxis.Limits = box(1:2);
        obj.YAxis.Limits = box(3:4);
        obj.ZAxis.Limits = box(5:6);
    end
    
    function box = viewBox(obj)
        % Compute the view box from the limits on the different axes
        box = [obj.XAxis.Limits obj.YAxis.Limits obj.ZAxis.Limits];
    end
    
    function setViewBox(obj, box)
        % set axes limits from viewbox values
        obj.XAxis.Limits = box(1:2);
        obj.YAxis.Limits = box(3:4);
        if length(box) > 4
            obj.ZAxis.Limits = box(5:6);
        end
    end
end % end methods

%% background image
methods
    function setBackgroundImage(obj, img)
        if isa(img, 'ImageNode')
            obj.BackgroundImage = img;
        else
            img = ImageNode(img);
            obj.BackgroundImage = img;
        end
        
        extent = physicalExtent(obj.BackgroundImage);
        obj.XAxis.Limits = extent([1 2]);
        obj.YAxis.Limits = extent([3 4]);
    end
end


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization

        % first add information about axes
        str.xAxis = toStruct(obj.XAxis);
        str.yAxis = toStruct(obj.YAxis);
        str.zAxis = toStruct(obj.ZAxis);

        str.axisLinesVisible = obj.AxisLinesVisible;

        str.rootNode = toStruct(obj.RootNode);
    end
    
    function write(obj, fileName, varargin)
        % Write into a JSON file
        
        % check existence of output directory
        [outputDir, tmp] = fileparts(fileName);  %#ok<ASGLU>
        if ~isempty(outputDir)
            if ~exist(outputDir, 'dir')
                error(['Output directory does not exist: ' outputDir]);
            end
        end
        
        % save the scene
        savejson('', toStruct(obj), 'FileName', fileName, varargin{:});
    end
end

methods (Static)
    function scene = fromStruct(str)
        % Create a new instance from a structure
        
        % create an empty scene
        scene = SceneGraph();
        
        % parse eventual axes information
        if isfield(str, 'xAxis')
            scene.XAxis = SceneAxis.fromStruct(str.xAxis);
        end
        if isfield(str, 'yAxis')
            scene.YAxis = SceneAxis.fromStruct(str.yAxis);
        end
        if isfield(str, 'zAxis')
            scene.ZAxis = SceneAxis.fromStruct(str.zAxis);
        end
                
        if isfield(str, 'axisLinesVisible')
            scene.AxisLinesVisible = str.axisLinesVisible;
        end
        
        % create default root node
        scene.RootNode = GroupNode;
        scene.RootNode.Name = 'Root';
        
        % recursively parse the root node
        if isfield(str, 'rootNode')
            scene.RootNode = SceneNode.fromStruct(str.rootNode);
        end
        
        % parse old background image data
        if isfield(str, 'backgroundImage')
            imageNode = ImageNode.fromStruct(str.backgroundImage);
            imageNode.Name = 'BackgroundImage';
            add(scene.RootNode, imageNode);
        end
        
        % parse old Shape data
        if isfield(str, 'shapes')
            shapes = GroupNode();
            shapes.Name = 'Shapes';
            for i = 1:length(str.shapes)
                add(shapes, ShapeNode.fromStruct(str.shapes{i}));
            end
            add(scene.RootNode, shapes);
        end
    end
    
    function scene = read(fileName)
        % Read a scene from a file in JSON format
        scene = SceneGraph.fromStruct(loadjson(fileName));
    end
end

end % end classdef

