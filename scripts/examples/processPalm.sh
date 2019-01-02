#/bin/sh
cd $1
iters=$2
echo "paste -d"," *_prj.txt.txt > input.csv"
paste -d"," *_prj.txt.txt > input.csv
echo "csvtool transpose input.csv > output.csv"
csvtool transpose input.csv > output.csv
rm input.csv

mkdir fsl_palm
cd fsl_palm
mv ../output.csv .

palm -i output.csv -s  tgtSurface.gii -save1-p -o palm1-p_$iters -n $iters
