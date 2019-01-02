addpath('/fs4/masi/parvatp/SoftwarePlugins/spm12');
addpath('~/masimatlab/trunk/users/parvatp/utils');
list = load('subjlist.txt');

ref_file = '/fs4/masi/parvatp/Projects/NODDI_Woodward/GBSS/TestData-GSBSSPipeline/TPM_template.nii.gz';
indir='/fs4/masi/parvatp/Projects/NODDI_Woodward/GBSS/MediaPaper/GSBSSData/WOODWARD_TCP';
maskdir = '/fs4/masi/parvatp/Projects/NODDI_Woodward/GBSS/MediaPaper/ValidationV2/masks';
outdir='/fs4/masi/parvatp/Projects/NODDI_Woodward/GBSS/MediaPaper/ValidationV2/GMProbability3';
mkdir(outdir);

%Create group folders
grp1dir = sprintf('%s/group1',outdir);
grp2dir = sprintf('%s/group2',outdir);
mkdir(grp1dir);
mkdir(grp2dir);

for i=1:length(list)
        subj=num2str(list(i));
        datadir = char(sprintf('%s/%s/%s/WOODWARD_TCP-x-%s-x-%s-x-301-x-MaCRUISE_v3_rev_3_1_0',indir,subj,subj,subj,subj));
        inVolume = char(sprintf('%s/%s/%s/WOODWARD_TCP-x-%s-x-%s-x-301-x-NDW_VBM_v1/GRAY/p1WOODWARD_TCP-x-%s-x-%s-x-301.nii',indir,subj,subj,subj,subj,subj,subj));
        if (~exist(sprintf('%s/',datadir),'dir'))
            datadir = char(sprintf('%s/%s/%s/WOODWARD_TCP-x-%s-x-%s-x-401-x-MaCRUISE_v3_rev_3_1_0',indir,subj,subj,subj,subj));
            inVolume = char(sprintf('%s/%s/%s/WOODWARD_TCP-x-%s-x-%s-x-401-x-NDW_VBM_v1/GRAY/p1WOODWARD_TCP-x-%s-x-%s-x-401.nii',indir,subj,subj,subj,subj,subj,subj));
            if (~exist(sprintf('%s/',datadir),'dir'))
                datadir = char(sprintf('%s/%s/%s/WOODWARD_TCP-x-%s-x-%s-x-501-x-MaCRUISE_v3_rev_3_1_0',indir,subj,subj,subj,subj));
                inVolume = char(sprintf('%s/%s/%s/WOODWARD_TCP-x-%s-x-%s-x-501-x-NDW_VBM_v1/GRAY/p1WOODWARD_TCP-x-%s-x-%s-x-501.nii',indir,subj,subj,subj,subj,subj,subj));
            end
        end
        if i<16
            system(sprintf('cp %s %s/%s_GMProb.nii',inVolume,grp1dir,subj));
            system(sprintf('cp %s/Surfaces_FreeView/target_image_GMimg_centralSurf.asc %s/%s_surf.asc',datadir,grp1dir,subj));
        else
            % modify image based on simulated artifacts
            system(sprintf('cp %s %s/%s_GMProb.nii',inVolume,grp2dir,subj));
            system(sprintf('cp %s/Surfaces_FreeView/target_image_GMimg_centralSurf.asc %s/%s_surf.asc',datadir,grp2dir,subj));
            antsdir = sprintf('%s/Surfaces_Ants',datadir);
            % simulate data for radius 1-5 masks and a change rate 1:10 in intensity
            % values 
            vol=load_untouch_nii(inVolume);  volimg=double(vol.img);
            for radius=1:5
                % bring mask back to subj space
                 %Ants Apply transform to labels
                system(sprintf('antsApplyTransforms -i %s/mask%d.nii.gz -o %s/mask%d.nii.gz -r %s -n NearestNeighbor -t [%s/output0GenericAffine.mat,1] -t %s/output1InverseWarp.nii.gz  ',maskdir,radius,grp2dir,radius,inVolume,antsdir,antsdir));               
                mask = load_untouch_nii_gz(sprintf('%s/mask%d.nii.gz',grp2dir,radius)); mask1=mask.img; clear mask;            
                for rate = 1:10
                    simdir = sprintf('%s/sim_r%d_p%d',grp2dir,radius,rate);
                    if ~exist(simdir,'dir') mkdir(simdir); end
                    % get the volume image, apply the rate of intensity
                    % change at corresponding mask locations
                    indices = find(mask1);
                    modimg=volimg; 
                    modimg(indices)=(rate/10)*volimg(indices);
                    modvol=vol; modvol.img = modimg;
                    save_untouch_nii(modvol,sprintf('%s/%s_GMProb.nii',simdir,subj));                    
                end
            end            
        end  
end

