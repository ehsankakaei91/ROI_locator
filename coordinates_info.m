function ROI = coordinates_info(x,y,z,S)
% gets the coordinates and name of the space, and returns a list of the
% regions corresponding to those coordinates in various atlases.
%
% ROI = COrrdinates_INFO(X,Y,Z,S) gets the coordinates X,Y,Z from the
% desired space S ['mni' or 'tal' (Talairach)] and returns the list of
% regions ROI in various atlases.
%
% The following atlases are included:
%   MD758 Dornas_Braun_2018
%   HCP Glasser_et_al_2016 (MMP)
%   Brodmann
%   CAREN (Doucet et.al 2019 Hum Brain Mapp)
%   Yeo 2011 J Neurophysiol
%   Wang et al. 2015 (topographic)
%   fsl HarvardOxford
%
% Ehsan Kakaei 2022
%
% See also atlas_location, tal2icbm_fsl, open_nii, mni_xyz_convert,MD758toOtherAtlases


a = which('MD758toOtherAtlases');
kk = find(a=='\' | a=='\',1,'last');
pth = a(1:kk); % where is MD758toOtherAtlases
MD758ROI = MD758toOtherAtlases(pth);
atlasnii = fullfile(pth,'atlases','MD758','ROI_MNI_MD758.nii');
ROI_correspond = atlas_location(atlasnii,x,y,z,S); % find parcels corresponding to the coordinates

notincluded = ROI_correspond==0; % not in MD758

tmp = MD758ROI(ones(numel(x),1));
a = struct2cell(tmp);
a(:,:,notincluded) = {nan};
tmp = cell2struct(a,fieldnames(tmp));
tmp(~notincluded) = MD758ROI(ROI_correspond(~notincluded)); 
ROI = tmp;
end