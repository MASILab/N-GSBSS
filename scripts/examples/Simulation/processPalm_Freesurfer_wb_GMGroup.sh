#/bin/sh
cd $1
iters=$2

grp1dir=/fs4/masi/parvatp/Projects/NODDI_Woodward/GBSS/MediaPaper/ValidationV2/GMProbability2/group1/FreeSurfer/Resampled_226848/smooth
basedir=/fs4/masi/parvatp/Projects/NODDI_Woodward/GBSS/MediaPaper/ValidationV2/GMProbability2

mkdir $1/wholebrain

echo "paste -d"," *lh*.txt > lh_input_grp2.csv"
paste -d"," *lh*.txt > lh_input_grp2.csv

echo "paste -d"," *rh*.txt > rh_input_grp2.csv"
paste -d"," *rh*.txt > rh_input_grp2.csv


echo "Merging left and right data"
cat lh_input_grp2.csv > input_grp2.csv
cat rh_input_grp2.csv >> input_grp2.csv
rm lh_input_grp2.csv
rm rh_input_grp2.csv

echo "csvtool transpose input_grp2.csv > wb_output_grp2.csv"
csvtool transpose input_grp2.csv > wb_output_grp2.csv
rm input_grp2.csv

cd $1/wholebrain
cat $grp1dir/wb_output_grp1.csv > wb_output.csv
cat ../wb_output_grp2.csv >> wb_output.csv

mkdir fsl_palm
cd fsl_palm
mv ../wb_output.csv .

echo /fs4/masi/parvatp/SoftwarePlugins/palm-alpha109/palm -i wb_output.csv -m /fs4/masi/parvatp/Projects/NODDI_Woodward/GBSS/MediaPaper/ValidationV2/fMRI/FreeSurfer/226848_mask.csv -save1-p -o wb_palm1-p_mask_$iters -n $iters -d ${basedir}/fsl_palm/design.mat -t ${basedir}/fsl_palm/design.con
/fs4/masi/parvatp/SoftwarePlugins/palm-alpha109/palm -i wb_output.csv -m /fs4/masi/parvatp/Projects/NODDI_Woodward/GBSS/MediaPaper/ValidationV2/fMRI/FreeSurfer/226848_mask.csv -save1-p -o wb_palm1-p_mask_$iters -n $iters -d ${basedir}/fsl_palm/design.mat -t ${basedir}/fsl_palm/design.con
