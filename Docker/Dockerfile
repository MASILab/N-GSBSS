# Use Ubuntu 16:04 base image
FROM ubuntu:latest

# Install xvfb-run, MATLAB MCR, set up INPUTS and OUTPUTS directories, etc...
# Note that java is required for gui to run with MATLAB
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends apt-utils &&\
    apt-get -y install wget bc &&\
    apt-get -y install zip unzip &&\
    apt-get -y install libxt-dev &&\
    apt-get -y install libxext6 &&\
    apt-get -y install libglu1 &&\
    apt-get -y install libxrandr2 &&\
    apt-get -y install ghostscript &&\
    apt-get -y install imagemagick &&\
    apt-get -y install openjdk-8-jre &&\
    apt-get -y install libstdc++6 &&\
    mkdir /tmp/matlab_mcr && \
    cd /tmp/matlab_mcr/ && \
    wget http://ssd.mathworks.com/supportfiles/downloads/R2017a/deployment_files/R2017a/installers/glnxa64/MCR_R2017a_glnxa64_installer.zip && \
    unzip MCR_R2017a_glnxa64_installer.zip && \
    ./install -agreeToLicense yes -mode silent && \
    rm -rf /tmp/matlab_mcr && \

    mkdir /INPUTS && \
    mkdir /OUTPUTS && \
    mkdir /extra

# Copy binaries and other files used in macruise parcel pipeline; for some reason absolute paths dont work
ADD extra /extra

# Set environment for MATLAB MCR
ENV LD_LIBRARY_PATH /usr/local/MATLAB/MATLAB_Runtime/v92/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v92/bin/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v92/sys/os/glnxa64:${LD_LIBRARY_PATH}

ENV SINGULARITY TRUE
