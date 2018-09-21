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
    
    % Description of x-axis, as a SceneAxis instance
    zAxis;
    
    % The bounding box of the current view. Stored as a 1-by-(2n) array.
    % Can be 2D or 3D
    % (to be deprecated)
    viewBox = [];
    
end % end properties


%% Constructor
methods
    function this = Scene(varargin)
    % Constructor for Scene class

    end

end % end constructors


%% Display Methods
methods
    function varargout = draw(this)
        % display in a new figure
        hFig = figure; 
        axis equal; hold on;
        if ~isempty(this.viewBox)
            axis(this.viewBox);
        end
        
        for iShape = 1:length(this.shapes)
            draw(this.shapes(iShape));
        end
        
        if nargout > 0
            varargout = {hFig};
        end
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

        % create a structure for the list of shapes
        str.shapes = cell(1, length(this.shapes));
        for i = 1:length(this.shapes)
            str.shapes{i} = toStruct(this.shapes(i));
        end
        if ~isempty(this.viewBox)
            str.viewBox = this.viewBox;
        end
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
        
        % parse list of shapes
        shapeList = str.shapes;
        for iShape = 1:length(shapeList)
            shape = Shape.fromStruct(shapeList{iShape});
            addShape(scene, shape);
        end
        
        % eventually parse viewBox
        if isfield(str, 'viewBox')
            scene.viewBox = str.viewBox;
        end
    end
    
    function scene = read(fileName)
        % Read a scene from a file in JSON format
        scene = Scene.fromStruct(loadjson(fileName));
    end
end

end % end classdef

