classdef ImageNode < handle
%IMAGENODE  One-line description here, please.
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
    % the path to the image file, as a char array
    filePath = '';
    
    % the image data, as a Matlab array
    imageData = [];
    
    % information for spatial calibration
    origin;
    spacing;
    
end % end properties


%% Constructor
methods
    function this = ImageNode(var1, varargin)
    % Constructor for ImageNode class

        if nargin == 0
            error('requires at least one input argument'),
        end
        
        if isa(var1, 'ImageNode')
            % copy constructor
            this.filePath = var1.filePath;
            this.imageData = var1.imageData;
            this.spacing = var1.spacing;
            this.origin = var1.origin;
            
        elseif ischar(var1)
            % intialize from file path
            this.filePath = var1;
            
        elseif isnumeric(var1)
            % initialisation constructor
            this.imageData = var1;
            
            % initialize spacing and origin from dimension
            initializeSpatialCalibration(this);
        else
            error('Unable to create image node');
        end
    end

end % end constructors


%% Methods
methods
    function readImageData(this)
        % read image data from file path and populate corresponding field
        this.imageData = imread(this.filePath);
        initializeSpatialCalibration(this);
    end
    
    function h = show(this, varargin)
        % display image data on current axis
        
        % compute physical extents
        dim = size(this.imageData);
        lx = (0:dim(2)-1) * this.spacing(1) + this.origin(1);
        ly = (0:dim(1)-1) * this.spacing(2) + this.origin(2);
        
        % display image with approriate spatial reference
        hh = imshow(this.imageData, 'XData', lx, 'YData', ly);
        
        if nargout > 0
            h = hh;
        end
    end

    
    function extent = physicalExtent(this)
        nd = ndims(this);
        
        % extract base data
        sz = size(this.imageData);
        sz = sz([2 1]);
        sp = this.spacing;
        or = this.origin;
        
        % put extent in array
        extent = (([zeros(nd, 1) sz']-.5).* [sp' sp'] + [or' or'])';
        
        % change array shape to get a single row
        extent = extent(:)';
    end
    
    function lx = xData(this)
        dim = size(this.imageData);
        lx = (0:dim(2)-1) * this.spacing(1) + this.origin(1);
    end
    
    function ly = yData(this)
        dim = size(this.imageData);
        ly = (0:dim(1)-1) * this.spacing(2) + this.origin(2);
    end
    
end % end methods

%% Private methods
methods (Access = private)
    function initializeSpatialCalibration(this)
        % setup spacing and origin from image data
        nd = 2;
        if ndims(this.imageData) > 2 && size(this.imageData, 3) > 3 %#ok<ISMAT>
            nd = 3;
        end
        this.spacing = ones(1, nd);
        this.origin = ones(1, nd);
    end
    
end % end methods



%% Serialization methods
methods
    function str = toStruct(this)
        % Convert to a structure to facilitate serialization

        str.filePath = this.filePath;
    end
    
    function write(this, fileName, varargin)
        % Write into a JSON file
        savejson('', toStruct(this), 'FileName', fileName, varargin{:});
    end
end

methods (Static)
    function node = fromStruct(str)
        % Creates a new instance from a structure
        
        % parse file path
        node = ImageNode(str.filePath);
        
        % parse optional fields
        if isfield(str, 'spacing')
            node.spacing = str.spacing;
        end
        if isfield(str, 'origin')
            node.origin = str.origin;
        end
    end
    
    function node = read(fileName)
        % Read a ImageNode instance from a file in JSON format
        node = ImageNode.fromStruct(loadjson(fileName));
    end
end

end % end classdef

