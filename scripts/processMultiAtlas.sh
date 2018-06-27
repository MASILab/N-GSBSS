#/bin/sh

T1=$1
mkdir testMultiAtlas
cd testMultiAtlas
mkdir INPUTS
mkdir OUTPUTS

cp $T1 INPUTS/T1.nii.gz
sudo docker run --rm -v $(pwd)/INPUTS/:/INPUTS/ -v $(pwd)/OUTPUTS/:/OUTPUTS/ vuiiscci/vuiiscci:Multi_Atlas_v2_1_0 xvfb-run -a --server-args="-screen 0 1920x1200x24 -ac +extension GLX" /extra/Multi_Atlas_v2_1_0
