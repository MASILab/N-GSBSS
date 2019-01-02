%% To generate mask for GM probablity simulation - Figure4
addpath('~/masi-fusion/src/ext');

%output location
outdir = '/fs4/masi/parvatp/Projects/NODDI_Woodward/GBSS/MediaPaper/ValidationV2/masks';
if ~exist(outdir,'dir')
    mkdir(outdir);
end

% Initialize input parameters
ref_file = '/fs4/masi/parvatp/SoftwarePlugins/spm12/toolbox/vbm8/avgT1_Dartel_IXI550_MNI152.nii';

% % Pick a location1
% centerX = 88;
% centerY = 101;
% centerZ = 60;
% % Pick a location2
% centerX = 77;
% centerY = 98;
% centerZ = 77;
% 
% % Pick a location2
% centerX = 79;
% centerY = 104;
% centerZ = 75;

% Pick a location2
centerX = 63;
centerY = 112;
centerZ = 52;

% Provide outputfile
for radius=1:5
    outmask = sprintf('%s/mask%d.nii.gz',outdir,radius);
    createMask(radius,centerX,centerY,centerZ, ref_file,outmask);
end

% Check the masks
figure; 
for radius=1:5
    outmask = load_untouch_nii_gz(sprintf('%s/mask%d.nii.gz',outdir,radius)); mask=double(outmask.img);
    subplot(1,5,radius);
    imagesc(mask(:,:,60)); title(sprintf('Radius%d',radius));
end
