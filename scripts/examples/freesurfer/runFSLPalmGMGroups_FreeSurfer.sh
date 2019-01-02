#!/bin/bash

basedir=/fs4/masi/parvatp/Projects/NODDI_Woodward/GBSS/MediaPaper/ValidationV2/GMProbability2

for radius in 3 4 5 
do
#for perc in 1 3 5 7 9 
for perc in 2 4 6 8 10 
do
	entry=sim_r${radius}_p${perc}
	grp2dir=${basedir}/group2/${entry}/FreeSurfer/Resampled_226848/smooth
	#echo $entry
	file=${grp2dir}/wholebrain/fsl_palm/wb_palm1-p_mask_5000_dat_tstat_fwep_c1.csv
#	echo $file
        if [ ! -e "$file" ]; then	
	    echo ./processPalm_Freesurfer_wb_GMGroup.sh $grp2dir 5000
	   ./processPalm_Freesurfer_wb_GMGroup.sh $grp2dir 5000 &
	else
	    echo  "$grp2dir fslpalm exist" 
	fi
done
done
