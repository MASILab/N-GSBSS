function run_separate_hemi(infile, out1, out2)
    %% initialization
    addpath('/home-nfs/masi-shared-home/home/local/VANDERBILT/lyui/Tools/CurveLabeling/io');
    addpath('/home-nfs/masi-shared-home/home/local/VANDERBILT/lyui/Tools/Tessellation/');

    stitch(infile,out1,out2);
end
