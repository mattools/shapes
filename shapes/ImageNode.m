classdef ImageNode < SceneNode
%IMAGENODE Contains information to represent an image within the scene
%
%   Class ImageNode
%
%   Example
%   ImageNode
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2018-10-15,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2018 INRA - BIA-BIBS.


%% Properties
properties
    Name = '';
    
    % the path to the image file, as a char array
    FilePath = '';
    
    % the image data, as a Matlab array
    ImageData = [];
    
    % the size of image, nx-by-ny
    ImageSize;

    % information for spatial calibration
    Spacing = [1 1];
    Origin = [1 1];
    
end % end properties


%% Constructor
methods
    function obj = ImageNode(var1, varargin)
    % Constructor for ImageNode class

        if nargin == 0
            error('requires at least one input argument'),
        end
        
        if isa(var1, 'ImageNode')
            % copy constructor
            obj.FilePath = var1.FilePath;
            obj.ImageData = var1.ImageData;
            obj.ImageSize = var1.ImageSize;
            obj.Spacing = var1.Spacing;
            obj.Origin = var1.Origin;
            
        elseif ischar(var1)
            % intialize from file path
            
            % create absolute file path
            file = java.io.File(var1);
            if ~file.exists()
                error('Could not resolve absolute path for %s.', var1);
            end
            
            if ~file.isAbsolute()
                var1 = fullfile(pwd, var1);
            end
                        
            obj.FilePath = var1;
            
            % determine image size (2D or 3D)
            info = imfinfo(obj.FilePath);
            if length(info) == 1
                obj.ImageSize = [info.Width info.Height];
            else
                obj.ImageSize = [info(1).Width info(1).Height length(info)];
                % update information for spatial calibration
                obj.Spacing = [1 1 1]; 
                obj.Origin = [1 1 1];
            end
            
        elseif isnumeric(var1)
            % initialisation constructor
            obj.ImageData = var1;
            
            % initialize Spacing and Origin from image data
            initializeSpatialCalibration(obj);
        else
            error('Unable to create image node');
        end
    end

end % end constructors


%% Methods
methods
    function readImageData(obj)
        % read image data from file path and populate corresponding field
        obj.ImageData = imread(obj.FilePath);
        initializeSpatialCalibration(obj);
    end
    
    function h = show(obj, varargin)
        warning('''show'' is deprecated, use ''draw''');
        h = draw(obj, varargin{:});
    end
    
    function extent = physicalExtent(obj)
        nd = length(obj.ImageSize);
        
        % extract base data
        sz = obj.ImageSize;
        sp = obj.Spacing;
        or = obj.Origin;
        
        % put extent in array
        extent = (([zeros(nd, 1) sz']-.5) .* [sp' sp'] + [or' or'])';
        
        % change array shape to get a single row
        extent = extent(:)';
    end
    
    function lx = xData(obj)
        dim = obj.ImageSize;
        lx = (0:dim(2)-1) * obj.Spacing(1) + obj.Origin(1);
    end
    
    function ly = yData(obj)
        dim = obj.ImageSize;
        ly = (0:dim(1)-1) * obj.Spacing(2) + obj.Origin(2);
    end
    
end % end methods

%% Private methods
methods (Access = private)
    function initializeSpatialCalibration(obj)
        % setup Spacing and Origin from image data

        % image dimensionality
        nd = 2;
        if ndims(obj.ImageData) > 2 && size(obj.ImageData, 3) > 3 %#ok<ISMAT>
            nd = 3;
        end
        
        % size in XY order
        dims = size(obj.ImageData);
        obj.ImageSize = dims([2 1 3:nd]);
        
        % init Spacing and Origin
        obj.Spacing = ones(1, nd);
        obj.Origin = ones(1, nd);
    end
    
end % end methods


%% Methods specializing the SceneNode superclass
methods
    function h = draw(obj, varargin)
        % display image data on current axis
        
        % read image data if necessary
        if isempty(obj.ImageData)
            data = imread(obj.FilePath);
        else
            data = obj.ImageData;
        end
        
        % compute physical extents
        dim = obj.ImageSize;
        lx = (0:dim(1)-1) * obj.Spacing(1) + obj.Origin(1);
        ly = (0:dim(2)-1) * obj.Spacing(2) + obj.Origin(2);
        
        % display image with approriate spatial reference
        hh = imshow(data, 'XData', lx, 'YData', ly);
        
        if nargout > 0
            h = hh;
        end
    end

    function box = boundingBox(obj)
        extent = physicalExtent(obj);
        box = [extent 0 0];
    end
    
    function printTree(obj, nIndents) %#ok<INUSL>
        str = [repmat('  ', 1, nIndents) '[ImageNode]'];
        disp(str);
    end
    
    function b = isLeaf(obj) %#ok<MANU>
        b = true;
    end
end


%% Serialization methods
methods
    function str = toStruct(obj)
        % Convert to a structure to facilitate serialization

        str = struct();
        
        % call scene node method
        convertSceneNodeFields(obj, str);

        str.filePath = obj.FilePath;
        str.imageSize = obj.ImageSize;
        str.spacing = obj.Spacing;
        str.origin = obj.Origin;
    end
    
    function write(obj, fileName, varargin)
        % Write into a JSON file
        savejson('', toStruct(obj), 'FileName', fileName, varargin{:});
    end
end

methods (Static)
    function node = fromStruct(str)
        % Creates a new instance from a structure
        
        % parse file path
        node = ImageNode(str.filePath);

        % parse SceneNode fields
        parseSceneNodeFields(node, str);

        % parse optional fields
        if isfield(str, 'imageSize')
            node.ImageSize = str.imageSize;
        end
        if isfield(str, 'spacing')
            node.Spacing = str.spacing;
        end
        if isfield(str, 'origin')
            node.Origin = str.origin;
        end
    end
    
    function node = read(fileName)
        % Read a ImageNode instance from a file in JSON format
        node = ImageNode.fromStruct(loadjson(fileName));
    end
end

end % end classdef

