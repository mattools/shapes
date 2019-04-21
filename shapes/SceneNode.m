classdef SceneNode < handle
%SCENENODE Abstract class for Node in a SceneGraph
%
%   Class SceneNode
%
%   Example
%   SceneNode
%
%   See also
%     SceneGraph, ShapeNode, GroupNode

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-04-01,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % the optional name of this node
    Name = '';
    
end % end properties


%% Constructor
methods
    function obj = SceneNode(varargin)
    % Constructor for SceneNode class

    end

end % end constructors


%% Methods
methods (Abstract)
    % Draw the current node
    h = draw(obj);
    
    % Returns the bounding box of this node, as a 1-by-6 row vector
    box = boundingBox(obj);
    
    printTree(obj, nIndents);

    % Determines whether the current node is a leaf (terminal) node
    b = isLeaf(obj);
        
end % end methods

%% Serialization methods
methods (Static)
    function node = fromStruct(str)
        % Create a new instance from a structure
        
        % Dispatch to sub-classes depending on content of the "type" field.
        switch lower(str.type)
            case 'shape', node = ShapeNode.fromStruct(str);
            case 'group', node = GroupNode.fromStruct(str);
            otherwise
                warning(['Unknown SceneNode type: ' type]);
        end
    end
    
    function node = read(fileName)
        % Read a node from a file in JSON format
        node = SceneNode.fromStruct(loadjson(fileName));
    end
end

methods (Access=protected)

    function obj = parseSceneNodeFields(obj, str)
        if isfield(str, 'name')
            obj.Name = str.name;
        end
    end
    
    function str = convertSceneNodeFields(obj, str)
        if ~isempty(obj.Name)
            str.name = obj.Name;
        end
    end
end

end % end classdef

