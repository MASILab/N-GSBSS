#!/bin/bash
outdir=$1
indir=$2
rh_sphere=${outdir}/rh.sphere.vtk
lh_sphere=${outdir}/lh.sphere.vtk
mkdir ${indir}/Resampled

for i in `cat subjectsdir.txt`
do
	mris_convert ${i}/Registration/lh.sphere.reg ${i}/Registration/lh.sphere.reg.vtk
	mris_convert ${i}/Registration/rh.sphere.reg ${i}/Registration/rh.sphere.reg.vtk

	subj=$(echo $i | cut -d'/' -f11-11)
	# Left hemisphere
	#Resample to icosohedron sphere
	SurfRemesh -t ${i}/Registration/lh.target_image_GMimg_centralSurf.sphere.vtk  -r ${lh_sphere} -p ${indir}/${subj}_lh_prop.vtk.txt --outputProperty ${indir}/Resampled/${subj}_lh_prop.res.txt --noheader
	#Resample to icosohedron sphere
	SurfRemesh -t ${i}/Registration/lh.sphere.reg.vtk  -r ${lh_sphere} -p ${indir}/Resampled/${subj}_lh_prop.res.txt.vtk.txt --outputProperty ${indir}/Resampled/${subj}_lh_prop.reg.txt --noheader
	# Right Hemisphere
	#Resample to icosohedron sphere
        SurfRemesh -t ${i}/Registration/rh.target_image_GMimg_centralSurf.sphere.vtk  -r ${rh_sphere} -p ${indir}/${subj}_rh_prop.vtk.txt --outputProperty ${indir}/Resampled/${subj}_rh_prop.res.txt --noheader
	#Resample to icosohedron sphere
        SurfRemesh -t ${i}/Registration/rh.sphere.reg.vtk  -r ${rh_sphere} -p ${indir}/Resampled/${subj}_rh_prop.res.txt.vtk.txt --outputProperty ${indir}/Resampled/${subj}_rh_prop.reg.txt --noheader

done
