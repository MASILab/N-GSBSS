addpath('/fs4/masi/parvatp/SoftwarePlugins/spm12');
addpath('~/masimatlab/trunk/users/parvatp/utils');
list = load('subjlist.txt');
outdir='/fs4/masi/parvatp/Projects/NODDI_Woodward/GBSS/MediaPaper/ValidationV2/GMProbability2';
indir='/fs4/masi/parvatp/Projects/NODDI_Woodward/GBSS/MediaPaper/GSBSSData/WOODWARD_TCP';
ref_file = '/fs4/masi/parvatp/SoftwarePlugins/spm12/toolbox/vbm8/avgT1_Dartel_IXI550_MNI152.nii';
grp1dir = sprintf('%s/group1',outdir);
grp2dir = sprintf('%s/group2',outdir);


for i=1:length(list)
    subj=num2str(list(i));
    datadir = char(sprintf('%s/%s/%s/WOODWARD_TCP-x-%s-x-%s-x-301-x-MaCRUISE_v3_rev_3_1_0',indir,subj,subj,subj,subj));
    %inVolume = char(sprintf('%s/%s/%s/WOODWARD_TCP-x-%s-x-%s-x-301-x-NDW_VBM_v1/GRAY/p1WOODWARD_TCP-x-%s-x-%s-x-301.nii',indir,subj,subj,subj,subj,subj,subj));
    if (~exist(sprintf('%s/',datadir),'dir'))
        datadir = char(sprintf('%s/%s/%s/WOODWARD_TCP-x-%s-x-%s-x-401-x-MaCRUISE_v3_rev_3_1_0',indir,subj,subj,subj,subj));
        %inVolume = char(sprintf('%s/%s/%s/WOODWARD_TCP-x-%s-x-%s-x-401-x-NDW_VBM_v1/GRAY/p1WOODWARD_TCP-x-%s-x-%s-x-401.nii',indir,subj,subj,subj,subj,subj,subj));
        if (~exist(sprintf('%s/',datadir),'dir'))
            datadir = char(sprintf('%s/%s/%s/WOODWARD_TCP-x-%s-x-%s-x-501-x-MaCRUISE_v3_rev_3_1_0',indir,subj,subj,subj,subj));
            %inVolume = char(sprintf('%s/%s/%s/WOODWARD_TCP-x-%s-x-%s-x-501-x-NDW_VBM_v1/GRAY/p1WOODWARD_TCP-x-%s-x-%s-x-501.nii',indir,subj,subj,subj,subj,subj,subj));
        end
    end
    resultdir = sprintf('%s/Surfaces_Ants',datadir);
    %baseline
    if i<16
        grpdir=grp1dir;
        
        subjdir = sprintf('%s/SubjSpace',grpdir); if ~exist(subjdir,'dir') mkdir(subjdir); end
        deformdir = sprintf('%s/DeformSpace2',grpdir); if ~exist(deformdir,'dir') mkdir(deformdir); end
        inVolume = sprintf('%s/%s_GMProb.nii',grpdir,subj);
        system(sprintf('gunzip %s.gz',inVolume));
    	%Ants Apply transform to labels
    	system(sprintf('antsApplyTransforms -i %s -o %s/%s_GMProb_reg.nii -r %s -n BSpline  -t %s/output1Warp.nii.gz  -t %s/output0GenericAffine.mat',inVolume,grpdir,subj,ref_file,resultdir,resultdir));   
    else
        grpdir=grp2dir;
        for radius=3:5
            for rate=1:2:10
                simdir = sprintf('%s/sim_r%d_p%d',grpdir,radius,rate);
                inVolume = sprintf('%s/%s_GMProb.nii',simdir,subj);               
                system(sprintf('gunzip %s.gz',inVolume));
    		system(sprintf('antsApplyTransforms -i %s -o %s/%s_GMProb_reg.nii -r %s -n BSpline  -t %s/output1Warp.nii.gz  -t %s/output0GenericAffine.mat',inVolume,simdir,subj,ref_file,resultdir,resultdir));   
            end
        end
        
    end
end

% Valdiate results Qualitatively - Paraview
% Validate results Quantitatively
