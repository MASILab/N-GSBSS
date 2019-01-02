#!/bin/bash
atlasdir=HCPpipelines/global/templates/standard_mesh_atlases/resample_fsaverage
basedir=$1
processdir=${basedir}/fMRIProcessed/SecondaryAnalysis/
cd ${processdir}
#mkdir GMProb
#cd GMProb
mkdir ODI2Smooth2
cd ODI2Smooth2

iters=1000
mkdir fsl_palm
cd fsl_palm
cat ${basedir}/odi2T1_s2_male_LH.csv > data_odi_lh.csv
cat ${basedir}/odi2T1_s2_female_LH.csv >> data_odi_lh.csv
cat ${basedir}/odi2T1_s2_male_RH.csv > data_odi_rh.csv
cat ${basedir}/odi2T1_s2_female_RH.csv >> data_odi_rh.csv
