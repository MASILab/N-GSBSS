#!/bin/bash
basedir=$1
processdir=${basedir}/fMRIProcessed/SecondaryAnalysis/
cd ${processdir}
#mkdir GMProb
#cd GMProb
mkdir GMProbSmooth
cd GMProbSmooth
design_ttest2 design 15 15

iters=1000

for radius in 3 4 5
do
for perc in 2 4 6 8 10
do
	#cd $processdir/GMProb
	cd $processdir/GMProbSmooth
	entry=sim_r${radius}_p${perc}
	echo $entry
	mkdir $entry
	cd $entry
	mkdir fsl_palm
	cd fsl_palm
	#cat ${basedir}/gmProb_grp1_WB.csv > data.csv
	#cat ${basedir}/gmProb_${entry}_grp2_WB.csv >> data.csv
	cat ${basedir}/gmProb_s2_grp1_WB.csv > data.csv
	cat ${basedir}/gmProb_s2_${entry}_grp2_WB.csv >> data.csv
        palm -i data.csv -d ${processdir}/GMProb/design.mat -t ${processdir}/GMProb/design.con -save1-p -o palm1-p_$iters -n $iters
done
done
