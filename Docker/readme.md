## Pull docker from repository
sudo docker pull vuiiscci/vuiiscci:GSBSS_v2_0_0

## Run docker
sudo docker run -it --rm -v  /customdir/INPUTS/:/INPUTS/ -v /customdir/OUTPUTS/:/OUTPUTS vuiiscci/vuiiscci:GSBSS_v2_0_0 /extra/run_gsbss_script.sh /usr/local/MATLAB/MATLAB_Runtime/v92/

## Input data structure
