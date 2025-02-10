function ROI = MD758toOtherAtlases(pth)
% gets the path of the atlas_conversion folder and returns the conversion
% between MD758 and other atlases.
%
% ROI = MD758TOOTHERATLASES(PTH) gets the path directroy PTH to the
% atlase_conversion folder and find the regions with highers probability
% corresponding to each of the parcels, and returns them as an output ROI.
%
% The following atlases are included:
%   HCP Glasser_et_al_2016 (MMP)
%   Brodmann
%   CAREN (Doucet et.al 2019 Hum Brain Mapp)
%   Yeo 2011 J Neurophysiol
%   Wang et al. 2015 (topographic)
%   fsl HarvardOxford
%
% see also open_nii , atlas_roi_position, atlas_conversion, mni_xyz_convert

if nargin<1
    pth = pwd;
end
addpath(genpath(pth))
fn = fullfile(pth,'atlases','MD2Others.mat');
if isfile(fn)
    load(fn)
else
    %% MD758
    atlasnii = fullfile(pth,'atlases','MD758','ROI_MNI_MD758.nii');
    atlaslist = fullfile(pth,'atlases','MD758','ROI_MNI_MD758_List.mat');
    roipos = atlas_roi_position(atlasnii,atlaslist);
    
    
    %% HCP Glasser_et_al_2016 (MMP)
    fname = fullfile(pth,'atlases','Glasser_et_al_2016-parcellation','HCP-MMP1_on_MNI152_ICBM2009a_nlin-2mm.nii');
    MMP2MD = atlas_conversion(atlasnii,fname); % maps atlas2 into atlas1
    nm = load(fullfile(pth,'atlases','Glasser_et_al_2016-parcellation','HCPMMP1_list.mat')); % ROI list
    HCPnames = nm.HCPMMP1_list(:,2);
    
    %% Brodmann
    fname =  fullfile(pth,'atlases','Brodmann','brodmann.nii');
    Brodmann2MD = atlas_conversion(atlasnii,fname);
    
    %% CAREN (Doucet et.al 2019 Hum Brain Mapp)
    fname = fullfile(pth,'atlases','CAREN','CAREN.nii');
    CAREN2MD = atlas_conversion(atlasnii,fname);
    CAREN_names = {'Salient','Central executive','Sensorimotor','Default','Visual'};
    %% Yeo 2011 J Neurophysiol
    fname = fullfile(pth,'atlases','Yeo_JNeurophysiol11_MNI152','Yeo2011_7Networks_MNI152_FreeSurferConformed1mm_LiberalMask.nii');
    Yeo2MD = atlas_conversion(atlasnii,fname);
    YEO_names = {'Visual','Somatomotor','Dorsal Attention','Ventral Attention',...
        'Limbic','Frontoparietal','Default'};
    %% Wang et al. 2015 (topographic)
    fname = fullfile(pth,'atlases','Wang_et_al_2015','maxprob_vol.nii');
    Wang2MD = atlas_conversion(atlasnii,fname);
    wang_names = {'V1v','V1d','V2v','V2d','V3v','V3d','hV4','VO1','VO2',...
        'PHC1','PHC2','MST','hMT','LO2','LO1','V3b','V3a','IPS0','IPS1','IPS2',...
        'IPS3','IPS4','IPS5','SPL1','FEF'};
    %% HarvardOxford
    fname = fullfile(pth,'atlases','fsl_HarvardOxford','HarvardOxford-cort-maxprob-thr25-2mm.nii');
    nm = load(fullfile(pth,'atlases','fsl_HarvardOxford','HarvardOxfordCortical_names.mat'));
    HROX2MD = atlas_conversion(atlasnii,fname);
    HROX_names = nm.HarvardOxfordCortical.Names;
    %% find corresponding parcels
    parcels = 1:758;
    for n = 1:numel(parcels)
        
        ROI(n).MD758_ID = parcels(n);
        ROI(n).MD758_Name = roipos( parcels(n)).Nom_L;
        
        % CAREN
        if ~isempty(CAREN2MD(parcels(n)).BestReg)
            CARENID = CAREN2MD(parcels(n)).BestReg;
            tmpnames = CAREN_names{CARENID(1)};
            for nc = 2:numel(CARENID)
                tmpnames = [tmpnames ' - ' CAREN_names{CARENID(nc)}];
            end
        else
            tmpnames = '---';
        end
        ROI(n).CAREN = tmpnames;
        
        % Yeo
        if ~isempty(Yeo2MD(parcels(n)).BestReg)
            YEOID = Yeo2MD(parcels(n)).BestReg;
            tmpnames = YEO_names{YEOID(1)};
            for nc = 2:numel(YEOID)
                tmpnames = [tmpnames ' - ' YEO_names{YEOID(nc)}];
            end
        else
            tmpnames = '---';
        end
        ROI(n).YEO = tmpnames;
        
        % MMP
        if ~isempty(MMP2MD(parcels(n)).BestReg)
            MMPID = MMP2MD(parcels(n)).BestReg;
            tmpnames = HCPnames{MMPID(1)};
            for nc = 2:numel(MMPID)
                tmpnames = [tmpnames ' - ' HCPnames{MMPID(nc)}];
            end
        else
            tmpnames = "---";
        end
        ROI(n).MMP = tmpnames;
        
        % brodmann
        if ~isempty(Brodmann2MD(parcels(n)).BestReg)
            BRDID = Brodmann2MD(parcels(n)).BestReg;
            
        else
            BRDID = nan;
        end
        ROI(n).Brodmann = BRDID;
        
        % wang
        if ~isempty(Wang2MD(parcels(n)).BestReg)
            KSTID = Wang2MD(parcels(n)).BestReg;
            tmpnames = wang_names{KSTID(1)};
            for nc = 2:numel(KSTID)
                tmpnames = [tmpnames ' - ' HCPnames{KSTID(nc)}];
            end
        else
            tmpnames = '---';
        end
        ROI(n).Wang = tmpnames;
        
        % HarvardOxford
        if ~isempty(HROX2MD(parcels(n)).BestReg)
            HROXID = HROX2MD(parcels(n)).BestReg;
            tmpnames = HROX_names{HROXID(1)};
            for nc = 2:numel(HROXID)
                tmpnames = [tmpnames ' - ' HCPnames{HROXID(nc)}];
            end
        else
            tmpnames = '---';
        end
        ROI(n).HarvardOxford = tmpnames;
        
    end
    %% (defined in Glesser 2016 & fox pnas2005 )
    mmp2md = [ROI.MMP]';
    istask_negative = contains(mmp2md,["_PGi_","_PGs_","_TE1a_","_7m_","_v23ab_","_10r_","_10v_"]); % Default mode
    tmp = num2cell(istask_negative);
    [ROI.istask_negative] = tmp{:};
    istask_positive = contains(mmp2md,["_PF_","_PHT_","_23c_","_46_"]); % task positive
    tmp = num2cell(istask_positive);
    [ROI.istask_positive] = tmp{:};
    %% Save output file
    save(fullfile(pth,'atlases','MD2Others.mat'),'ROI')
end
end