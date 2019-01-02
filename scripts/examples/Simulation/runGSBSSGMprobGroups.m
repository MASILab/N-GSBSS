addpath('/fs4/masi/parvatp/SoftwarePlugins/spm12');
addpath('~/masimatlab/trunk/users/parvatp/utils');
addpath('~/masi-fusion/src/ext');
addpath('/home-nfs/masi-shared-home/home/local/VANDERBILT/parvatp/masimatlab/trunk/users/parvatp/NODDI_Woodward/GBSS/MI2017Code/GSBSS_v2/Repository');
addpath(genpath('/fs4/masi/parvatp/SoftwarePlugins/SpectralMatching/DiffeoSpectralMatching'));


list = load('subjlist.txt');
indir='/fs4/masi/parvatp/Projects/NODDI_Woodward/GBSS/MediaPaper/GSBSSData/WOODWARD_TCP';

%Initialize inputs
opts.ref_file = '/fs4/masi/parvatp/SoftwarePlugins/spm12/toolbox/vbm8/avgT1_Dartel_IXI550_MNI152.nii';
opts.tgtsurface = sprintf('%s/226848/226848/WOODWARD_TCP-x-226848-x-226848-x-301-x-MaCRUISE_v3_rev_3_1_0/Surfaces_Ants/centralSurf_antsDeform.gii',indir);
opts.antspath = '/fs4/masi/parvatp/SoftwarePlugins/antsbin/bin/';

%opts.volimages = {'con0011','con0014','con0015','vic','odi','viso','fa'};
opts.txtprops = {};
opts.labels = '';

opts.resampleflag=0;
opts.searchrange=0;

basedir = '/fs4/masi/parvatp/Projects/NODDI_Woodward/GBSS/MediaPaper/ValidationV2/GMProbability2';
grp1dir = sprintf('%s/group1',basedir);
grp2dir = sprintf('%s/group2',basedir);


for i=16:length(list)
%for i=1:15
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
      opts.surfregdir = [datadir '/Surfaces_MNI/SpectralAnts_226848/'];
      opts.regdir = [datadir '/Surfaces_Ants/'];
      opts.prefix=subj;
      
    %baseline
    if i<16
        grpdir=grp1dir;
        opts.datadir = grpdir;   
        opts.T1 = [opts.datadir '/T1.nii'];
        opts.insurface = [opts.datadir '/' subj '_surf.asc'];
        %subjdir = sprintf('%s/SubjSpace',grpdir); if ~exist(subjdir,'dir') mkdir(subjdir); end
        deformdir = sprintf('%s/DeformSpace2/',grpdir); if ~exist(deformdir,'dir') mkdir(deformdir); end
        opts.outdir = deformdir;
        opts.volimages = {sprintf('%s_GMProb',subj) };
        system(sprintf('gunzip %s/%s.gz',opts.datadir,opts.volimages{1}));    
        GSBSS(opts);
%         inVolume = sprintf('%s/%s_GMProb.nii',grpdir,subj);
%         system(sprintf('gunzip %s.gz',inVolume));
        
    else
        grpdir=grp2dir;
        opts.T1 = [grpdir '/T1.nii'];
        opts.insurface = [grpdir '/' subj '_surf.asc']; 
        for radius=3:5
            for rate=1:2:10
                simdir = sprintf('%s/sim_r%d_p%d',grpdir,radius,rate);
		if ~exist(sprintf('%s/sim_r%d_p%d/DeformSpace2/%s_deformedMetrics.vtk',grpdir,radius,rate,subj))        
                opts.datadir = simdir;   
                deformdir = sprintf('%s/DeformSpace2',simdir); if ~exist(deformdir,'dir') mkdir(deformdir); end
                opts.outdir = deformdir;
                opts.volimages = {sprintf('%s_GMProb',subj) };
                system(sprintf('gunzip %s/%s.gz',opts.datadir,opts.volimages{1}));    
                GSBSS(opts);
		else 
			display(sprintf('sim_r%d_p%d/DeformSpace2/%s_deformedMetrics.vtk exists',radius,rate,subj))
		end
            end
        end
        
    end
end

% Valdiate results Qualitatively - Paraview
% Validate results Quantitatively
