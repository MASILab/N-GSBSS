function getThickness(thickness_file, insurface,insurface0,T1,datadir)
%% Process thickness file
thickness_file
insurface
insurface0
T1
load(thickness_file);
dlmwrite([datadir '/thickness_inner.txt'],whole_thickness');

tgtsurface=insurface;
inSurface=insurface0;
ref_file=T1;
surfregdir=datadir;
NRRegisterSurface(tgtsurface, inSurface, 'SpectralMatch',ref_file, datadir);

map = load(sprintf('%s/mappings.mat',datadir));
mapping=map.params.corr12;

metric = load([datadir '/thickness_inner.txt']);
prjmetricfile = sprintf('%s/thickness.txt',datadir);
projectSurfaceMetric(metric,mapping,prjmetricfile);
system(sprintf('rm %s/mappings.mat',surfregdir));

