classdef SceneNode < handle
%SCENENODE Abstract class for Node in a SceneGraph
%
%   Class SceneNode
%
%   Example
%   SceneNode
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-04-01,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
end % end properties


%% Constructor
methods
    function obj = SceneNode(varargin)
    % Constructor for SceneNode class

    end

end % end constructors


%% Methods
methods (Abstract)
    b = isLeaf(obj);
        
end % end methods

end % end classdef

