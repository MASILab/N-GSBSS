iters=10000
basedir=$1
atlasdir=$2

mkdir fsl_palm
mkdir fsl_palm/LH
mkdir fsl_palm/RH
#
cp $basedir/cue_LH.csv fsl_palm/LH/
cp $basedir//cue_RH.csv fsl_palm/RH/
#
cd $basedir 
cd fsl_palm/LH
palm -i cue_LH.csv -s  $refdir/MNINonLinear/fsaverage_LR32k/subject.L.midthickness.32k_fs_LR.surf.gii -save1-p -o palm1-p_$iters -n $iters
#
cd ../RH
palm -i cue_RH.csv -s  $refdir/MNINonLinear/fsaverage_LR32k/subject.R.midthickness.32k_fs_LR.surf.gii -save1-p -o palm1-p_$iters -n $iters
