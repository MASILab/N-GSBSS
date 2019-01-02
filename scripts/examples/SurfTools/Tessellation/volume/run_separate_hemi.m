function run_separate_hemi(outDirectory, name, infile, out1, out2)
    %% initialization
    addpath('/home-nfs/masi-shared-home/home/local/VANDERBILT/lyui/Tools/CurveLabeling/io');
    addpath('/home-nfs/masi-shared-home/home/local/VANDERBILT/lyui/Tools/Tessellation/');

    cmd = ['cp ' infile ' ' outDirectory '/' name '.vtk'];
    %disp(cmd);
    system(cmd);

    cmd = [outDirectory '/' name '.vtk'];
    %disp(cmd);
    [vert, face]=read_vtk(cmd);
    
    % vertex position
    vert = [vert, ones(size(vert,1),1)];
    vert = vert * [0,0,1,-80;1,0,0,120;0,1,0,-100]';
    vert = vert(:, 1:3);
    face = [face(:, 3) face(:, 2) face(:, 1)];

    c = mean(vert);
    vert = vert - repmat(c,size(vert,1),1);
    vert = vert - repmat([-32,0,0],size(vert,1),1);
    fp = fopen([outDirectory '/' name '.vtk'],'w');
    fprintf(fp, '# vtk DataFile Version 3.0\nvtk output\nASCII\nDATASET POLYDATA\n');
    fprintf(fp, 'POINTS %d float\n', size(vert, 1));
    fprintf(fp, '%f %f %f\n', vert');
    fprintf(fp, 'POLYGONS %d %d\n', size(face, 1), size(face, 1) * 4);
    fprintf(fp, '3 %d %d %d\n', face');
    fclose(fp);

    cmd = ['mris_convert ' outDirectory '/' name '.vtk ' outDirectory '/' name '.fs'];
    %disp(cmd);
    system(cmd);

    write_surf2([outDirectory '/' name '.fs'],[outDirectory '/' name '.fs.header']);

    cmd = ['mris_fill -c -r 1 ' outDirectory '/' name '.fs.header ' outDirectory '/' name '.fs.header.mgz'];
    %disp(cmd);
    system(cmd);

    stitch([outDirectory '/' name '.fs.header.mgz'],[outDirectory '/' name '.vtk'],out1,out2);

    cmd = ['rm ' outDirectory '/' name '.vtk ' outDirectory '/' name '.fs ' outDirectory '/' name '.fs.header ' outDirectory '/' name '.fs.header.mgz'];
    %disp(cmd);
    system(cmd);

end
