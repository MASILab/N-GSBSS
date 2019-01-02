function hemiSeperateProperty(libpath,tgtdir,subj,datadir)
addpath('SurfLibrary');

chdir(tgtdir);
surfname='tgtSurface.vtk';
out_lh='lh_tgtSurface.vtk';
out_rh='rh_tgtSurface.vtk';
out_tab='tgtSurface.IdTable.txt';
out_lh_mask='lh_tgtSurface_mask.txt';
out_rh_mask='rh_tgtSurface_mask.txt';
% whole brain prop file to be hemi seperated
prop_file=sprintf('%s/%s_prop_prj.txt',datadir,subj);

% separate hemisphers
%tab=hemi_separation(surfname, out_lh, out_rh, out_tab, out_lh_mask, out_rh_mask, surfname)
maptable = load(out_tab);

% seperate properties
lhmap=maptable(~ismember(maptable(:,3),[1]),:);
rhmap=maptable(ismember(maptable(:,3),[1]),:);

lG1 = read_vtk(out_lh);
rG1 = read_vtk(out_rh);

lhprop = zeros(length(lG1),1);
rhprop = zeros(length(rG1),1);
prop=load(prop_file);
lhprop(lhmap(:,2)+1) = prop(lhmap(:,1)+1);
rhprop(rhmap(:,2)+1) = prop(rhmap(:,1)+1);

mkdir(sprintf('%s/HemiSeperate',datadir));
csvwrite(sprintf('%s/HemiSeperate/lh_%s_prop_prj.txt',datadir,subj),lhprop);
csvwrite(sprintf('%s/HemiSeperate/rh_%s_prop_prj.txt',datadir,subj),rhprop);
