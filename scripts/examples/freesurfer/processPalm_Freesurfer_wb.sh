#/bin/sh
cd $1
iters=$2

cd $1
mkdir $1/wholebrain
cp *lh*txt.txt wholebrain/
cp *rh*txt.txt wholebrain/

cd $1/wholebrain/

echo "paste -d"," *lh*.txt.txt > lh_input.csv"
paste -d"," *lh*.txt.txt > lh_input.csv

echo "paste -d"," *rh*.txt.txt > rh_input.csv"
paste -d"," *rh*.txt.txt > rh_input.csv

echo "Merging left and right data"
cat lh_input.csv > input.csv
cat rh_input.csv >> input.csv

echo "csvtool transpose input.csv > wb_output.csv"
csvtool transpose input.csv > wb_output.csv
rm input.csv

mkdir fsl_palm
cd fsl_palm
mv ../wb_output.csv .

/fs4/masi/parvatp/SoftwarePlugins/palm-alpha109/palm -i wb_output.csv -m tgtSurface_mask.csv -save1-p -o wb_palm1-p_mask_$iters -n $iters
