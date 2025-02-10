function ROI = atlas_roi_position(atlasnii,atlaslist)
% gets the atlas nifti file and ROI name-list and returns the geometrical
% center of each ROI in MNI space.
%
% ROI = ATLAS_ROI_POSITION(ATLASNII,ATLASLIST) gets the atlas nifti file
% ATLASNII and the list of names of regions ATLASLIST, and returns the list
% of ROIs with their geometrical center in MNI space.
%
% Ehsan Kakaei 2022
%
% see also open_nii, mni_xyz_convert

load(atlaslist)
tmp = open_nii(atlasnii);
data = tmp.dat();
regionID = unique(data);
regionID (ismember(regionID,0)) = []; % excluding regions out of atlas

for ind = 1:length(regionID)
    index = find(data==regionID(ind));
    [x,y,z] = ind2sub(size(data),index);
    [mni_x,mni_y,mni_z] = mni_xyz_convert(x,y,z,tmp.mat,'voxel');
    roi_ind = find([ROI(:).ID]==regionID(ind));
    ROI(roi_ind).x = mean(mni_x);
    ROI(roi_ind).y = mean(mni_y);
    ROI(roi_ind).z = mean(mni_z);
end

end