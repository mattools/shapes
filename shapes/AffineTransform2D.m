classdef AffineTransform2D < handle
%AFFINETRANSFORM2D A 2D affine transform defined by its matrix
%
%   Class AffineTransform2D
%
%   Example
%   AffineTransform2D
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-04-03,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % the coefficients of this transform, in order [m00 m01 m02 m10 m11 m12].
    % (initialized to identity)
    Coeffs = [1 0 0  0 1 0];
    
end % end properties


%% Static factories
methods (Static)
    function obj = createTranslation(shift, varargin)
        % trans = AffineTransform2D.createTranslation([dx dy])
        if isnumeric(shift)
            if all(size(shift) == [1 2])
                dx = shift(1);
                dy = shift(2);
            elseif isscalar(shift) && isscalar(varargin{1})
                dx = shift;
                dy = varargin{1};
            end
        else
            error('requires numeric input');
        end
         
        obj = AffineTransform2D([1 0 dx 0 1 dy]);
    end
    
    function obj = createRotation(theta)
        % trans = AffineTransform2D.createRotation(angleInRadians)
        cot = cos(theta);
        sit = sin(theta);
        obj = AffineTransform2D([cot -sit 0 sit cot 0]);
    end
    
end


%% Constructor
methods
    function obj = AffineTransform2D(coeffs)
    % Constructor for AffineTransform2D class
    
        if nargin < 1
            coeffs = [1 0 0  0 1 0];
        end
        if ~isnumeric(coeffs) 
            error('requires a numeric input');
        end
        if all(size(coeffs) == 3)
            % convert 3x3 matrix to 1x6 row vector (drop last row)
            coeffs = [coeffs(1,1:3) coeffs(2,1:3)];
        end
    
        obj.Coeffs = coeffs;
    end
    
end % end constructors


%% Methods
methods
    function point2 = transformPoint(obj, point)
        % point2 = transformPoint(obj, point)
        if ~isa(point, 'Point2D')
            error('Requires and instance of Point2D');
        end
        
        coeffs = obj.Coeffs;
        x2 = coeffs(1) * point.X + coeffs(2) * point.Y + coeffs(3);
        y2 = coeffs(4) * point.X + coeffs(5) * point.Y + coeffs(6);
        point2 = Point2D(x2, y2);
    end
    
    function pts2 = transformCoords(obj, pts)
        % coords2 = transformPoint(obj, coords)
        % coords should be a N-by-2 numeric array.
        % coords2 has the same size as coords
        
        coeffs = obj.Coeffs;
        pts2 = zeros(size(pts));
        pts2(:,1) = coeffs(1) * pts(:,1) + coeffs(2) * pts(:,2) + coeffs(3);
        pts2(:,2) = coeffs(4) * pts(:,1) + coeffs(5) * pts(:,2) + coeffs(6);
    end
    
    function b = isIdentity(obj, varargin)
        if isempty(varargin)
            tol = 1e-10;
        else
            tol = varargin{1};
        end
        b = all(abs(obj.Coeffs - [1 0 0 0 1 0]) < tol);
    end
    
    function res = concatenate(obj, obj2)
        mat2 = affineMatrix(obj) * affineMatrix(obj2);
        res = AffineTransform2D(mat2);
    end
    
    function res = invert(obj)
        res = AffineTransform2D(inv(affineMatrix(obj)));
    end
    function res = inverse(obj)
        res = AffineTransform2D(inv(affineMatrix(obj)));
    end

    function mat = affineMatrix(obj)
        mat = [obj.Coeffs(1:3) ; obj.Coeffs(4:6) ; 0 0 1];
    end

end % end methods


%% Overload Matlab computation functions
methods
    function res = mtimes(obj, obj2)
        mat2 = affineMatrix(obj) * affineMatrix(obj2);
        res = AffineTransform2D(mat2);
    end
end


%% Serialization methods
methods
    function write(obj, fileName, varargin)
        % Writes box representation into a JSON file
        % 
        % Requires implementation of the "toStruct" method.
        
        if exist('savejson', 'file') == 0
            error('Requires the ''jsonlab'' library');
        end
        
        savejson('', toStruct(obj), 'FileName', fileName, varargin{:});
    end
    
    function str = toStruct(obj)
        % Converts to a structure to facilitate serialization
        str = struct(...
            'type', 'AffineTransform2D', ...
            'matrix', [obj.Coeffs(1:3) ; obj.Coeffs(4:6) ; 0 0 1]);
    end
end

methods (Static)
    function box = read(fileName)
        % Reads box information from a file in JSON format
        if exist('loadjson', 'file') == 0
            error('Requires the ''jsonlab'' library');
        end
        box = AffineTransform2D.fromStruct(loadjson(fileName));
    end
    
    function transfo = fromStruct(str)
        % Creates a new instance from a structure
        transfo = AffineTransform2D(str.matrix);
    end
end

end % end classdef

