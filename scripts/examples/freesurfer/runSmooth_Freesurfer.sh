#!/bin/bash
input=$1
basedir=$2
outdir=$3
lh_tgtSurface=lh_tgtSurface.res.vtk
rh_tgtSurface=rh_tgtSurface.res.vtk
mkdir $outdir
echo $DATE_WITH_TIME
   # Geodescic distance ---
   DATE_WITH_TIME=`date "+%Y-%m-%d-%H:%M:%S"`
   echo "$DATE_WITH_TIME:Starting 2mm smoothing"
   GeodesicSmoothing -i $lh_tgtSurface -p $basedir/lh_${input}_prj_res.prj.txt --size 2 -o $outdir/lh_${input}_odi_prj_res_2mm.txt --writevtk --saven
   GeodesicSmoothing -i $rh_tgtSurface -p $basedir/rh_${input}_prj_res.prj.txt --size 2 -o $outdir/rh_${input}_odi_prj_res_2mm.txt --writevtk --saven
