source $HCPDIR/Pipelines-3.26.1/Examples/Scripts/SetUpHCPPipeline.sh
GlobalScripts=${HCPPIPEDIR_Global}
LOGDIR=/logs
basedir=$1
#   echo "$i"   
i=$2
session=$i
subj=$(echo $session | cut -d'_' -f1-2 )

## RUN RECON-ALL 
PROCESSDIR=${basedir}/${session}
mkdir $PROCESSDIR

T1=${basedir}/${subj}/${session}/MaCRUISE_v3/Raw/T1.nii.gz
    DIRECTORY=$PROCESSDIR/$i/
    if [ ! -f "$T1" ]; then
        echo $i T1 doesnt exist
    fi
    #if [ -f "$DIRECTORY/recon-all.done" ]; then
    if [ -f "$DIRECTORY/mri/aparc.a2009s+aseg.mgz" ]; then
        echo $i
    fi
    #if [ ! -f "$DIRECTORY/recon-all.done" ]; then
    if [ ! -f "$DIRECTORY/mri/aparc.a2009s+aseg.mgz" ]; then
        echo "$i doesnt exist"
        rm -r $PROCESSDIR/$i
        echo "recon-all -i  $T1 -s  $i -sd $PROCESSDIR -all -parallel -openmp 4 > $LOGDIR/$i.log  "
        recon-all -i  $T1 -s  $i -sd $PROCESSDIR -all -parallel -openmp 4 > $LOGDIR/$i.log
    fi
~       
## CIFTIFY RECON-ALL 
DATADIR=${basedir}
PROCESSDIR=$DATADIR/CiftiProcessed3
LOGDIR=$DATADIR/logs

mkdir $PROCESSDIR
mkdir $LOGDIR

    DIRECTORY=$DATADIR/$i/$i
    if [  -f "$DIRECTORY/mri/aparc.a2009s+aseg.mgz" ]; then
        if [ ! -f "$PROCESSDIR/$i/MNINonLinear/${i}.L.inflated.164k_fs_LR.surf.gii" ]; then
                echo $i
                #rm -r $PROCESSDIR/$i
                echo "ciftify_recon_all --surf-reg FS --resample-to-T1w32k --fs-subjects-dir $DATADIR/$i --ciftify-work-dir $PROCESSDIR $i -v > ${i}_ciftify.log &"
                ciftify_recon_all --surf-reg FS --resample-to-T1w32k --fs-subjects-dir $DATADIR/$i --ciftify-work-dir $PROCESSDIR $i -v > ${i}_ciftify.log &
        fi
    fi

## Diffusion Processing 
DIFFUSIONDIR=$DATADIR/DiffProcessed3
mkdir $DIFFUSIONDIR
LOGDIR=$DATADIR/logs
mkdir $LOGDIR

session=$1
subj=$(echo $session | cut -d'_' -f1-2 )
i=$session

   echo "$i"   
    DIRECTORY=$PROCESSDIR/$i/MNINonLinear/Results/odi2T1
        mkdir $DIFFUSIONDIR/$i
        b0=${basedir2}/${subj}/${session}/dtiQA_v6/PREPROCESSED/b0.nii.gz
        ODI=${basedir}/${subj}/${session}/Amico_Multi_v2/AMICO/FIT0001.nii.gz

        if [ ! -f "$DIFFUSIONDIR/$i/ODI2_T1.nii.gz" ]; then
        # Generate wmseg mask from freesurfer outputs (FSL fast is not working) so this custom step added
        echo "Generating WM mask"
        fslmaths $PROCESSDIR/$i/T1w/aparc.a2009s+aseg.nii.gz -uthr 1000 -bin $DIFFUSIONDIR/$i/gmmask
        fslmaths $PROCESSDIR/$i/T1w/wmparc.nii.gz -thr 100 $DIFFUSIONDIR/$i/wmparc1
        fslmaths $DIFFUSIONDIR/$i/wmparc1.nii.gz -mas $DIFFUSIONDIR/$i/gmmask.nii.gz -bin $DIFFUSIONDIR/$i/wmseg

        # Apply Diffusion to Structural mapping 
        echo "Register diffusion to T1"
        if [ ! -f "$DIFFUSIONDIR/$i/b0_v2.nii.gz" ]; then
        ${GlobalScripts}/epi_reg_dof --dof=6 --epi=${b0} --t1=$PROCESSDIR/$i/T1w/T1w.nii.gz --t1brain=$PROCESSDIR/$i/T1w/T1w_brain.nii.gz --out=$DIFFUSIONDIR/$i/b0_v2 --wmseg=$DIFFUSIONDIR/$i/wmseg.nii.gz
        fi

        # Apply warp to other maps (Here we are interested in only ODI)
#       fslroi $DATADIR/Data/$i/FIT_parameters.nii.gz $DATADIR/Data/$i/ODI.nii.gz 1 1
        $FSLDIR/bin/applywarp -i $ODI -r $PROCESSDIR/$i/T1w/T1w.nii.gz -o $DIFFUSIONDIR/$i/ODI2_T1 --premat=$DIFFUSIONDIR/$i/b0_v2.mat --interp=spline
        fi
        # Ciftify diffusion results
        echo "Ciftify diffusion results"
        if [ ! -d "$PROCESSDIR/$i/odi2T1" ]; then
        ciftify_subject_fmri --surf-reg FS --ciftify-work-dir $PROCESSDIR $DIFFUSIONDIR/$i/ODI2_T1.nii.gz $i odi2T1
        cifti_vis_fmri snaps --ciftify-work-dir $PROCESSDIR odi2T1 $i
        fi

    if [ -f "$DIRECTORY/odi2T1_Atlas_s0.dtseries.nii" ]; then
    if [ ! -f "$DIRECTORY/odi2T1_Atlas_s2.dtseries.nii" ]; then
        echo "$i smoothing"
      echo wb_command -cifti-smoothing\
      ${PROCESSDIR}/${i}/MNINonLinear/Results/odi2T1/odi2T1_Atlas_s0.dtseries.nii \
      2 2 COLUMN\
      ${PROCESSDIR}/${i}/MNINonLinear/Results/odi2T1/odi2T1_Atlas_s2.dtseries.nii \
      -left-surface ${PROCESSDIR}/${i}/MNINonLinear/fsaverage_LR32k/${i}.L.midthickness.32k_fs_LR.surf.gii \
      -right-surface ${PROCESSDIR}/${i}/MNINonLinear/fsaverage_LR32k/${i}.R.midthickness.32k_fs_LR.surf.gii     
      wb_command -cifti-smoothing\
      ${PROCESSDIR}/${i}/MNINonLinear/Results/odi2T1/odi2T1_Atlas_s0.dtseries.nii \
      2 2 COLUMN\
      ${PROCESSDIR}/${i}/MNINonLinear/Results/odi2T1/odi2T1_Atlas_s2.dtseries.nii \
      -left-surface ${PROCESSDIR}/${i}/MNINonLinear/fsaverage_LR32k/${i}.L.midthickness.32k_fs_LR.surf.gii \
      -right-surface ${PROCESSDIR}/${i}/MNINonLinear/fsaverage_LR32k/${i}.R.midthickness.32k_fs_LR.surf.gii
fi
fi
         
