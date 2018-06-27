#/bin/sh

T1=$1
SEG=$2
mkdir testMaCruise
cd testMaCruise
mkdir INPUTS
mkdir OUTPUTS

cp $T1 INPUTS/T1.nii.gz
cp $SEG INPUTS/
sudo docker run --rm -v $(pwd)/INPUTS/:/INPUTS/ -v $(pwd)/OUTPUTS/:/OUTPUTS/ vuiiscci/vuiiscci:MaCRUISE_v3_1_0 xvfb-run -a --server-args="-screen 0 1920x1200x24 -ac +extension GLX" /extra/MaCRUISE_v3_1_0
