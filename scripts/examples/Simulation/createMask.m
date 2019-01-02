function createMask(radius,centerX,centerY,centerZ, ref_file,outmask)
    % provide nifti file
    [filepath,name,ext] = fileparts(ref_file) 
    if strcmp(ext, '.gz')
        vol = load_untouch_nii_gz(ref_file);
    else if strcmp(ext, '.nii')
            vol = load_untouch_nii(ref_file);
        else
            display('Please provide a NIFTI file');
        end
    end
    img = vol.img;
    [imageSizeX, imageSizeY, imageSizeZ] = size(img);
    [columnsInImage, rowsInImage, pagesInImage] = meshgrid(1:imageSizeX,1:imageSizeY, 1:imageSizeZ);
    sphereVoxels = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 + (pagesInImage - centerZ).^2 <=    radius.^2;
    mask1 = vol; 
    mask1.img = permute(sphereVoxels,[2 1 3]);
    % save the mask file
    [filepath,name,ext] = fileparts(outmask) 
    if strcmp(ext, '.gz')
         save_untouch_nii_gz(mask1,outmask);
    else if strcmp(ext, '.nii')
            save_untouch_nii(mask1,outmask);
        else
            display('Please provide a NIFTI file');
        end
    end
   