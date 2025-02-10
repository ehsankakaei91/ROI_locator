function ROI_correspond = atlas_location(atlasnii,x,y,z,S)
% gets nifti files of an atlas and returns the ROIs corresponding to the
% given coordinates in the given space.
%
% ROI_CORRESPOND = ATLAS_LOCATION(ATLASNII,X,Y,Z,SPACE) gets the nifti file
% ATLASNII of an atlas, coordinates X,Y,Z in the desired space S and returns
% the corresponding ROI_CORRESPOND.
%
% Spaces: 'mni', 'tal' (FSL Talairach) and 'vox'
%
% Ehsan Kakaei 2022
%
% see also tal2icbm_fsl, open_nii, mni_xyz_convert


F1 = open_nii(atlasnii);
Dat1 = F1.dat(); % nifti data to a matrix

M1 = F1.mat; % transformation mat
if strcmp(S,'mni')
    [Cx,Cy,Cz] = mni_xyz_convert(x,y,z,M1,'mni'); % voxel coordinates of atlas    
    Xp = round(Cx);
    Yp = round(Cy);
    Zp = round(Cz);
elseif strcmp(S,'tal')
    
    x = x(:)';
    y = y(:)';
    z = z(:)';
    outpoints = tal2icbm_fsl([x;y;z]);
    Xp = outpoints(1,:);
    Yp = outpoints(2,:);
    Zp = outpoints(3,:);
    
    [Cx,Cy,Cz] = mni_xyz_convert(Xp,Yp,Zp,M1,'mni'); % voxel coordinates of atlas    
    Xp = round(Cx);
    Yp = round(Cy);
    Zp = round(Cz);
elseif strcmp(S,'voxel')
    Xp = x;
    Yp = y;
    Zp = z;
end
id = sub2ind(size(Dat1),Xp,Yp,Zp);
ROI_correspond = Dat1(id);
end