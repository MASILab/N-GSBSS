indir=$1
tgt_Surface=${indir}/tgtSurface.vtk
outdir=$indir/HemiSeperate
mkdir $outdir

ref_sphere=${indir}/ic6.vtk
sep_cortex ${tgt_Surface} ${outdir}/lh_tgtSurface.vtk ${outdir}/rh_tgtSurface.vtk

echo "creating lh sphere"
# Step1 spherical mapping
echo "Step1 - Spherical mapping start"
timestamp
make_sphere_freesurfer $outdir/lh_tgtSurface.vtk $outdir/lh_tgtSurface.sphere.vtk 1
echo "Step1 - Spherical mapping end"
timestamp

echo "creating rh sphere"
# Step1 spherical mapping
echo "Step1 - Spherical mapping start"
timestamp
make_sphere_freesurfer $outdir/rh_tgtSurface.vtk $outdir/rh_tgtSurface.sphere.vtk 1
echo "Step1 - Spherical mapping end"
timestamp

# Step2 Resample surface
echo "Step2 - Resample start"
timestamp
SurfRemesh -i ${outdir}/lh_tgtSurface.vtk -t ${outdir}/lh_tgtSurface.sphere.vtk -r $ref_sphere -o ${outdir}/lh_tgtSurface.res.vtk
SurfRemesh -i ${outdir}/rh_tgtSurface.vtk -t ${outdir}/rh_tgtSurface.sphere.vtk -r $ref_sphere -o ${outdir}/rh_tgtSurface.res.vtk
echo "Step2 - Resample end"
timestamp

# Step3 Resample property
#echo "Step3 - Resample property start"
#timestamp
#cd ${output}
#echo ${output}
#mris_convert lh.target_image_GMimg_centralSurf.res.vtk lh.centralSurf.res.gii
##
#SurfRemesh -t lh.target_image_GMimg_centralSurf.sphere.vtk  -r ${ref_sphere} -p lh.prop.txt --outputProperty lh.prop.res.txt --noheader
#echo "Step3 - Resample property end"
#timestamp
