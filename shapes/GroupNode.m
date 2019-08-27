classdef GroupNode < SceneNode
% Contatenates a group of nodes.
%
%   Class GroupNode
%
%   Example
%     grp = GroupNode();
%     
%
%   See also
%     SceneNode
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-04-03,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties    
    % The list of children, as a 1-by-N cell array containing SceneNode instances.
    Children = {};
    
end % end properties


%% Constructor
methods
    function obj = GroupNode(varargin)
        % Constructor for GroupNode class
        
        while length(varargin) > 1
            name = varargin{1};
            value = varargin{2};
            if strcmpi(name, 'Name')
                obj.Name = value;
            elseif strcmpi(name, 'Visible')
                obj.Visible = value;
            else
                error('Unknown parameter for GroupNode');
            end
            varargin(1:2) = [];
        end
    end

end % end constructors


%% Methods
methods
    function add(obj, node)
        if ~isa(node, 'SceneNode')
            error('Requires a SceneNode object');
        end
        obj.Children = [obj.Children, {node}];
    end
    
end % end methods


%% Methods specializing the SceneNode superclass
methods
    function varargout = draw(obj)
        % Draw all children referenced by this group.
        
        nChildren = length(obj.Children);
        h = cell(1, nChildren);
        
        for iChild = 1:nChildren
            h{iChild} = draw(obj.Children{iChild});
        end
        
        if nargout > 0
            varargout = {h};
        end
    end
    
    function node = transform(obj, transfo)
        nChildren = length(obj.Children);
        children = cell(1, nChildren);
        for i = 1:nChildren
            children{i} = transform(obj.Children{i}, transfo);
        end
        node = GroupNode(children);
    end
    
    function box = boundingBox(obj)
        % Return the bounding box of this node, as a 1-by-6 row vector.
        minCoords =  [inf inf inf];
        maxCoords = -[inf inf inf];
        for iChild = 1:length(obj.Children)
            box = boundingBox(obj.Children{iChild});
            minCoords = min(minCoords, box([1 3 5]));
            maxCoords = max(maxCoords, box([2 4 6]));
        end
        box = [minCoords ; maxCoords];
        box = box(:)';
    end
    
    function printTree(obj, nIndents)
        str = [repmat('  ', 1, nIndents) '[GroupNode]'];
        disp(str);
        for i = 1:length(obj.Children)
            printTree(obj.Children{i}, nIndents+1);
        end
    end
    
    function b = isLeaf(obj)
        % Return true only if this node contains no children.
        b = isempty(obj.Children);
    end
end

%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization.
        
        % set type
        str = struct('Type', 'Group');

        % call scene node method
        str = convertSceneNodeFields(obj, str);
        
        % allocate memory for children array
        str.Children = cell(1, length(obj.Children));

        % populate child nodes
        for iChild = 1:length(obj.Children)
             str.Children{iChild} = toStruct(obj.Children{iChild});
        end
    end
    
    function write(obj, fileName, varargin)
        % Write into a JSON file.
        
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
    function node = fromStruct(str)
        % Create a new instance from a structure.
        
        % create an empty node
        node = GroupNode();
        
        parseSceneNodeFields(node, str);
        
        % parse list of Children
        for iChild = 1:length(str.Children)
            strChild = str.Children{iChild};
            child = SceneNode.fromStruct(strChild);
            add(node, child);
        end
    end
    
    function node = read(fileName)
        % Read a node from a file in JSON format.
        node = GroupNode.fromStruct(loadjson(fileName));
    end
end

end % end classdef
