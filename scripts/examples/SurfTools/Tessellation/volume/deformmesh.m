function deformmesh(input, output)
%% initialization
addpath('/home-nfs/masi-shared-home/home/local/VANDERBILT/lyui/Tools/CurveLabeling/io');

[vert, face]=read_vtk(input);
vert = [vert, ones(size(vert,1),1)];
vert = vert * [0,0,1,-80;1,0,0,120;0,1,0,-100]';
vert = vert(:, 1:3);
face = [face(:, 3) face(:, 2) face(:, 1)];

fp = fopen(output,'w');
fprintf(fp, '# vtk DataFile Version 3.0\nvtk output\nASCII\nDATASET POLYDATA\n');
fprintf(fp, 'POINTS %d float\n', size(vert, 1));
fprintf(fp, '%f %f %f\n', vert');
fprintf(fp, 'POLYGONS %d %d\n', size(face, 1), size(face, 1) * 4);
fprintf(fp, '3 %d %d %d\n', face');
fclose(fp);
end
