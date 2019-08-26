classdef AffineTransform3D < handle
% A 3D affine transform defined by its matrix.
%
%   Class AffineTransform3D
%
%   Example
%   AffineTransform3D
%
%   See also
%   AffineTransform2D

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-04-03,    using Matlab 9.5.0.944444 (R2018b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    % the coefficients of the transform
    % (initialized to identity)
    Coeffs = [1 0 0 0 ; 0 1 0 0; 0 0 1 0];
    
end % end properties

%% Static factories
methods (Static)
    function obj = createTranslation(shift, varargin)
        % trans = AffineTransform2D.createTranslation([dx dy])
        if isnumeric(shift)
            if all(size(shift) == [1 3])
                dx = shift(1);
                dy = shift(2);
                dz = shift(3);
            elseif isscalar(shift) && isscalar(varargin{1}) && isscalar(varargin{2})
                dx = shift;
                dy = varargin{1};
                dz = varargin{2};
            end
        else
            error('requires numeric input');
        end
         
        obj = AffineTransform3D([1 0 0 dx ; 0 1 0 dy ; 0 0 1 dz; 0 0 0 1]);
    end
end


%% Constructor
methods
    function obj = AffineTransform3D(mat)
    % Constructor for AffineTransform3D class
    
        if nargin < 1
            mat = eye(4);
        end
        if ~isnumeric(mat) || any(size(mat) ~= 4)
            error('requires a 4x4 matrix as input');
        end
    
        obj.Coeffs = [mat(1,:) mat(2,:) mat(3,:)];
    end
    
end % end constructors


%% Methods
methods
    function pts2 = transformCoords(obj, pts)
        % coords2 = transformPoint(obj, coords)
        % coords should be a N-by-2 numeric array.
        % coords2 has the same size as coords
        
        coeffs = obj.Coeffs;
        pts2 = zeros(size(pts));
        pts2(:,1) = coeffs(1) * pts(:,1) + coeffs(2) * pts(:,2) + coeffs(3) * pts(:,3) + coeffs(4);
        pts2(:,2) = coeffs(5) * pts(:,1) + coeffs(6) * pts(:,2) + coeffs(7) * pts(:,3) + coeffs(8);
        pts2(:,3) = coeffs(9) * pts(:,1) + coeffs(10) * pts(:,2) + coeffs(11) * pts(:,3) + coeffs(12);
    end
    
    function b = isIdentity(obj, varargin)
        if isempty(varargin)
            tol = 1e-10;
        else
            tol = varargin{1};
        end
        b = all(abs(obj.Coeffs - [1 0 0 0  0 1 0 0  0 0 1 0]) < tol);
    end
    
    function res = concatenate(obj, obj2)
        mat2 = affineMatrix(obj) * affineMatrix(obj2);
        res = AffineTransform3D(mat2);
    end
    
    
    function res = inverse(obj)
        res = AffineTransform3D(inv(affineMatrix(obj)));
    end

    function mat = affineMatrix(obj)
        mat = [obj.Coeffs(1:4) ; obj.Coeffs(5:8) ; obj.Coeffs(9:12) ; 0 0 0 1];
    end

end % end methods

%% Overload Matlab computation functions
methods
    function res = mtimes(obj, obj2)
        mat2 = affineMatrix(obj) * affineMatrix(obj2);
        res = AffineTransform3D(mat2);
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
            'Type', 'AffineTransform3D', ...
            'Matrix', [obj.Coeffs(1:4) ; obj.Coeffs(5:8) ; obj.Coeffs(9:12) ; 0 0 0 1]);
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
        transfo = AffineTransform3D(str.Matrix);
    end
end

end % end classdef

