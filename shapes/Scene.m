classdef Scene < handle
% A container of shape instances.
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
    % the set of Shapes within obj scene. 
    % Stored as a struct array.
    Shapes;
    
    % Description of x-axis, as a SceneAxis instance
    XAxis;
    
    % Description of y-axis, as a SceneAxis instance
    YAxis;
    
    % Description of z-axis, as a SceneAxis instance
    ZAxis;

    % an optional background image, as an instance of ImageNode
    BackgroundImage;
    
    % indicates whether main axes are visible or not (boolean)
    AxisLinesVisible = true;
    
    % base directory for saving data
    BaseDir = pwd;
    
end % end properties


%% Constructor
methods
    function obj = Scene(varargin)
        % Constructor for Scene class
        
        % create new axes
        obj.XAxis = SceneAxis();
        obj.YAxis = SceneAxis();
        obj.ZAxis = SceneAxis();
        
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
        
        for iShape = 1:length(obj.Shapes)
            addShape(res, Shape(obj.Shapes(iShape)));
        end
        for iShape = 1:length(that.Shapes)
            addShape(res, Shape(that.Shapes(iShape)));
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
        
        % start by background image
        if ~isempty(obj.BackgroundImage)
            show(obj.BackgroundImage);
        end
        
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

        for iShape = 1:length(obj.Shapes)
            draw(obj.Shapes(iShape));
        end
        
        if nargout > 0
            varargout = {hFig};
        end
    end
    
    function fitBoundsToShape(obj)
        % updates the bounds of the axis such that they contain all Shapes
        % (with finite geometries)

        % avoid case with no shape
        if length(obj.Shapes) < 1
            return;
        end
        
        % initial box
        box = [inf -inf inf -inf inf -inf];
        
        % iterate over Shapes
        for iShape = 1:length(obj.Shapes)
            shape = obj.Shapes(iShape);
            geom = shape.Geometry;
            
            if ismethod(geom, 'boundingBox')
                bbox = boundingBox(geom);
                box(1) = min(box(1), bbox.XMin);
                box(2) = max(box(2), bbox.XMax);
                box(3) = min(box(3), bbox.YMin);
                box(4) = max(box(4), bbox.YMax);
                
                % eventually process 3D coords
                if isa(bbox, 'Box3D')
                    box(5) = min(box(5), bbox.ZMin);
                    box(6) = max(box(6), bbox.ZMax);
                end
            end
        end
        
        % check presence of infinite
        if any(~isfinite(box(1:4)))
            warning('Unable to determine bounding box from existing geometries');
            return;
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

%% Shapes management

methods
    function s = addShape(obj, s)
        % Add a given shape to this scene, and return the new shape
        % shape = addShape(scene, Point2D(4, 3));
        if isa(s, 'Geometry')
            s = Shape(s);
        end
        obj.Shapes = [obj.Shapes s];
    end
    
    function removeShape(obj, s)
        % remove a given shape from this scene
        ind = [];
        for i = 1:length(obj.Shapes)
            if obj.Shapes(i) == s
                ind = i;
                break;
            end
        end
        if isempty(ind)
            disp('could not find shape to remove');
            return;
        end
        obj.Shapes(ind) = [];
    end
    
    function Shapes = getShapes(obj)
        % return a cell array containing the Shapes in this scene
        Shapes = obj.Shapes;
    end
    
    function clearShapes(obj)
        % clear the Shapes within this scene
        obj.Shapes = {};
    end
    
end

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
        str.XAxis = toStruct(obj.XAxis);
        str.YAxis = toStruct(obj.YAxis);
        str.ZAxis = toStruct(obj.ZAxis);

        if ~isempty(obj.BackgroundImage)
            str.BackgroundImage = toStruct(obj.BackgroundImage);
        end
        
        str.AxisLinesVisible = obj.AxisLinesVisible;

        % create a structure for the list of Shapes
        % (use it as last fields to finish by the more numerous data)
        str.Shapes = cell(1, length(obj.Shapes));
        for i = 1:length(obj.Shapes)
            str.Shapes{i} = toStruct(obj.Shapes(i));
        end
        
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
        scene = Scene();
        
        % parse eventual axes information
        if isfield(str, 'XAxis')
            scene.XAxis = SceneAxis.fromStruct(str.XAxis);
        elseif isfield(str, 'xAxis')
            scene.XAxis = SceneAxis.fromStruct(str.xAxis);
        end
        if isfield(str, 'YAxis')
            scene.YAxis = SceneAxis.fromStruct(str.YAxis);
        elseif isfield(str, 'yAxis')
            scene.YAxis = SceneAxis.fromStruct(str.yAxis);
        end
        if isfield(str, 'ZAxis')
            scene.ZAxis = SceneAxis.fromStruct(str.ZAxis);
        elseif isfield(str, 'zAxis')
            scene.ZAxis = SceneAxis.fromStruct(str.zAxis);
        end
        
        if isfield(str, 'BackgroundImage')
            scene.BackgroundImage = ImageNode.fromStruct(str.BackgroundImage);
        elseif isfield(str, 'backgroundImage')
            scene.BackgroundImage = ImageNode.fromStruct(str.backgroundImage);
        end
        
        if isfield(str, 'AxisLinesVisible')
            scene.AxisLinesVisible = str.AxisLinesVisible;
        elseif isfield(str, 'axisLinesVisible')
            scene.AxisLinesVisible = str.axisLinesVisible;
        end
        
        % parse list of Shapes
        if isfield(str, 'Shapes')
            for iShape = 1:length(str.Shapes)
                shape = Shape.fromStruct(str.Shapes{iShape});
                addShape(scene, shape);
            end
        elseif isfield(str, 'shapes')
            for iShape = 1:length(str.shapes)
                shape = Shape.fromStruct(str.shapes{iShape});
                addShape(scene, shape);
            end
        end
    end
    
    function scene = read(fileName)
        % Read a scene from a file in JSON format
        scene = Scene.fromStruct(loadjson(fileName));
    end
end

end % end classdef

