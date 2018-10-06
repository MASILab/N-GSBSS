## Pull docker from repository
sudo docker pull vuiiscci/gsbss:3.0.0

## Run docker
sudo docker run -it --rm -v  /customdir/INPUTS/:/INPUTS/ -v /customdir/OUTPUTS/:/OUTPUTS vuiiscci/gsbss:3.0.0 /extra/run_gsbss_script.sh /usr/local/MATLAB/MATLAB_Runtime/v92/

## Input data structure
https://github.com/MASILab/N-GSBSS/wiki

This has been tested on Ubuntu 16.04 and Mac OS
