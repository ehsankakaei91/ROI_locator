function ROI_correspond = atlas_conversion(atlasnii1,atlasnii2)
% gets nifti files of two atlases and reports which regions correspond to
% which.
%
% ROI_CORRESPOND = ATLAS_CONVERSION(ATLASNII1,ATLASNII2) get the nifti
% files ATLASNII1 and ATLASNII2 of two atlases and returns the
% corresponding regions of ATLASNII2 in space of ATLASNII1. 
% 
% Ehsan Kakaei 2022
%
% see also mni_xyz_convert, open_nii

F1 = open_nii(atlasnii1);
F2 = open_nii(atlasnii2);

Dat1 = F1.dat();
Dat2 = F2.dat();

NP1 = unique(Dat1);
NP1(NP1==0) = []; % Unique IDs

NP2 = unique(Dat2);
NP2(NP2==0) = []; % Unique IDs

M1 = F1.mat;% transformation mat
M2 = F2.mat;% transformation mat

% ROI_correspond = struct;
for nr = 1:numel(NP1)
    current_reg = NP1(nr);
    id = find(Dat1==current_reg);
    [X,Y,Z] = ind2sub(size(Dat1),id); % voxel coordinates
    [Cx,Cy,Cz] = mni_xyz_convert(X,Y,Z,M1,'voxel'); % mni coordinates of atlas 1
    [Xp,Yp,Zp] = mni_xyz_convert(Cx,Cy,Cz,M2,'mni'); % voxel coordinates of atlas 2
    
    Xp = round(Xp);
    Yp = round(Yp);
    Zp = round(Zp);
    
    id = sub2ind(size(Dat2),Xp,Yp,Zp);
    
    tmp = Dat2(id); % corresponding regions in atlas2
    Reg2 = unique(tmp);
    bins = Reg2+([-0.5 0.5]');
    bins = bins(:);
    P = histcounts(tmp,bins,'Normalization','probability');
    P(P==0) = []; % Probability of each region
    % Best region
    tmpP = P(Reg2~=0); % discard non-overlapping voxels
    tmpR = Reg2(Reg2~=0); % discard non-overlapping voxels
    [~,ii] = max(tmpP);
    BestReg = tmpR(ii);
    BestRegP = tmpP(ii);
    
    ROI_correspond(nr).current_reg = current_reg;
    ROI_correspond(nr).BestReg = BestReg;
    ROI_correspond(nr).BestRegP = BestRegP;
    ROI_correspond(nr).Regs = Reg2;
    ROI_correspond(nr).P = P;
    
end
end