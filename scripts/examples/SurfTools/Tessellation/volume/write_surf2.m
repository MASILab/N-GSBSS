function write_surf2(fname, outname)
%
% [vertex_coords, faces] = read_surf(fname)
% reads a the vertex coordinates and face lists from a surface file
% note that reading the faces from a quad file can take a very long
% time due to the goofy format that they are stored in. If the faces
% output variable is not specified, they will not be read so it 
% should execute pretty quickly.
%


%
% read_surf.m
%
% Original Author: Bruce Fischl
% CVS Revision Info:
%    $Author: nicks $
%    $Date: 2013/01/22 20:59:09 $
%    $Revision: 1.4.2.1 $
%
% Copyright © 2011 The General Hospital Corporation (Boston, MA) "MGH"
%
% Terms and conditions for use, reproduction, distribution and contribution
% are found in the 'FreeSurfer Software License Agreement' contained
% in the file 'LICENSE' found in the FreeSurfer distribution, and here:
%
% https://surfer.nmr.mgh.harvard.edu/fswiki/FreeSurferSoftwareLicense
%
% Reporting: freesurfer@nmr.mgh.harvard.edu
%


%fid = fopen(fname, 'r') ;
%nvertices = fscanf(fid, '%d', 1);
%all = fscanf(fid, '%d %f %f %f %f\n', [5, nvertices]) ;
%curv = all(5, :)' ;

% open it as a big-endian file


%QUAD_FILE_MAGIC_NUMBER =  (-1 & 0x00ffffff) ;
%NEW_QUAD_FILE_MAGIC_NUMBER =  (-3 & 0x00ffffff) ;

TRIANGLE_FILE_MAGIC_NUMBER =  16777214 ;
QUAD_FILE_MAGIC_NUMBER =  16777215 ;

fid = fopen(fname, 'rb', 'b') ;
if (fid < 0)
  str = sprintf('could not open curvature file %s.', fname) ;
  error(str) ;
end

fid2 = fopen(outname, 'wb', 'b') ;
if (fid2 < 0)
  str = sprintf('could not open curvature file %s.', outname) ;
  error(str) ;
end

b1 = fread(fid, 1, 'uchar') ;
fwrite(fid2, b1, 'uchar') ;
b2 = fread(fid, 1, 'uchar') ;
fwrite(fid2, b2, 'uchar') ;
b3 = fread(fid, 1, 'uchar') ;
fwrite(fid2, b3, 'uchar') ;

magic = bitshift(b1, 16) + bitshift(b2,8) + b3 ;

if(magic == QUAD_FILE_MAGIC_NUMBER)
  vnum = fread3(fid) ;
  fnum = fread3(fid) ;
  vertex_coords = fread(fid, vnum*3, 'int16') ./ 100 ; 
  if (nargout > 1)
    for i=1:fnum
      for n=1:4
	faces(i,n) = fread3(fid) ;
      end
    end
  end
elseif (magic == TRIANGLE_FILE_MAGIC_NUMBER)
  b = fgets(fid) ;
  fwrite(fid2, b, 'char') ;
  %fprintf(fid2, '%s', b) ;
  b = fgets(fid) ;
  fwrite(fid2, b, 'char') ;
  %fprintf(fid2, '%s', b) ;
  
  vnum = fread(fid, 1, 'int32') ;
  fwrite(fid2, int32(vnum), 'int32') ;
  fnum = fread(fid, 1, 'int32') ;
  fwrite(fid2, int32(fnum), 'int32') ;
  vertex_coords = fread(fid, vnum*3, 'float32') ; 
  fwrite(fid2, vertex_coords, 'float32') ;
  
  faces = fread(fid, fnum*3, 'int32') ;
  fwrite(fid2, int32(faces), 'int32') ;
  
%   flags=fread(fid, 12, 'uchar');
  
  fwrite(fid2, [0 0 0 2 0 0 0 0 0 0 0 20], 'uchar');
  %tags=fread(fid, 100000, 'uchar');
  %fwrite(fid2, tags, 'uchar');
  %fprintf('%s\n',tags);
  new_tags={'valid = 1  # volume info valid'; ...
    'filename = ../mri/filled-pretess255.mgz'; ...
    'volume = 256 256 256'; ...
    'voxelsize = 1.000000000000000e+00 1.000000000000000e+00 1.000000000000000e+00'; ...
    'xras   = -1.000000000000000e+00 0.000000000000000e+00 0.000000000000000e+00'; ...
    'yras   = 0.000000000000000e+00 0.000000000000000e+00 -1.000000000000000e+00'; ...
    'zras   = 0.000000000000000e+00 1.000000000000000e+00 0.000000000000000e+00'; ...
    'cras   = -1.007999877929688e+02 -1.280000000000000e+02 1.280000000000000e+02'};
  for i=1:size(new_tags,1)
    %fprintf('%s',tags2);
    tags2 = sprintf('%s\n', new_tags{i});
    fwrite(fid2, tags2, 'uchar');
  end
end

fclose(fid) ;
fclose(fid2) ;
