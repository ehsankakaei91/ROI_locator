function [cx,cy,cz] = mni_xyz_convert(x,y,z,m,s)
% converts the mni coordinates to voxel indices and vice versa
%
% [CX,CY,CZ] = MNI_XYZ_CONVERT(X,Y,Z,M,S) gets the coordinates X,Y and Z
% in the space S and converts them to CX,CY and CZ respectively, using the
% transformation matrix M (indicated in the header of the nifti file).
%
% possible input space S: 'mni' (default)| 'voxel'
% Ehsan Kakaei 8.7.2019

% vectorize (columns)
x = x(:);
y = y(:);
z = z(:); 
if nargin<4
    m = [-2,0,0,92;0,2,0,-128;0,0,2,-74;0,0,0,1]; % in our case! 
elseif nargin<5
    s = 'mni';
end
if length(x)~=length(y) || length(x)~=length(z)
    error('dimension missmatch between input coordinates')
elseif ~isequal(size(m),[4 4])
    error('transformatin matrix should be a 4-by-4 matrix')
end
switch s
    case 'voxel'
        tmp = m*[x';y';z';ones(1,length(x))];
    case 'mni'
        tmp = inv(m)*[x';y';z';ones(1,length(x))];
end
cx = tmp(1,:);
cy = tmp(2,:);
cz = tmp(3,:);
end