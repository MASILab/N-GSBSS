function runFreeSurferMapping(basedir,indir,subj)

    inVolume = sprintf('%s/%s_volmetric.nii',basedir,subj);
    
    inSurface = sprintf('%s/Surfaces_FreeView/target_image_GMimg_centralSurf.asc',datadir1); 
    outputVtk = sprintf('%s/FreeSurfer/%s_prop.vtk',basedir,subj);
        
    getMetricsOnSurface(inSurface, inVolume,outputVtk);
    
    prop = load(sprintf('%s/FreeSurfer/%s_prop.vtk.txt',basedir,subj));
    maptable = load(sprintf('%s/target_image_GMimg_centralSurf.IdTable.txt',datadir));
    
    % seperate properties
    lhmap=maptable(~ismember(maptable(:,3),[1]),:);
    rhmap=maptable(ismember(maptable(:,3),[1]),:);
    
    lhSurface = sprintf('%s/lh.target_image_GMimg_centralSurf.gii',datadir);
    lG1 = gifti(lhSurface);
    lhprop = zeros(length(lG1.vertices),1);
    
    rhSurface = sprintf('%s/rh.target_image_GMimg_centralSurf.gii',datadir);
    rG1 = gifti(rhSurface);
    rhprop = zeros(length(rG1.vertices),1);
    
    lhprop(lhmap(:,2)+1) = prop(lhmap(:,1)+1);
    rhprop(rhmap(:,2)+1) = prop(rhmap(:,1)+1);
    
    
    lhOutputVtk = sprintf('%s/FreeSurfer/%s_lh_prop.vtk',basedir,subj);
    getPropertyOnVtkSurface(lhSurface,lhOutputVtk,{'lhprop'},[lhprop]);
     
    rhOutputVtk = sprintf('%s/FreeSurfer/%s_rh_prop.vtk',basedir,subj);
    getPropertyOnVtkSurface(rhSurface,rhOutputVtk,{'rhprop'},[rhprop]);
%    
    metric_file = sprintf('%s.txt',lhOutputVtk);
    volfile = fopen(metric_file,'w');
    fprintf(volfile, '%f\n', lhprop);
    fclose(volfile);

    metric_file = sprintf('%s.txt',rhOutputVtk);
    volfile = fopen(metric_file,'w');
    fprintf(volfile, '%f\n', rhprop);
    fclose(volfile);
   
end
