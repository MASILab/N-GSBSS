function [vd, v, f] = separate_vol(volname, surfname)
    addpath(genpath('/home/local/VANDERBILT/lyui/Tools/CurveLabeling/io'));
    
    vol = MRIread(volname);
    
    volume =vol.vol;
    volume = padarray(volume, [20, 20, 20]);

    [~, ~, vent] = findTwoHemispheres(volume);
    
    [v,f]=read_vtk(surfname);
    
    center = mean(v);
    v0 = v - repmat(center + [-32,0,0], size(v,1), 1);
    v0 = v0 - repmat([0.8 -1 0.2],size(v0,1),1);    % this is heuristic!
    v0 = [v0 ones(size(v0,1),1)];
    v0 = v0 / vol.tkrvox2ras';
    v0=v0(:,1:3);
    v0 = v0 + repmat([20 20 20],size(v0,1),1);
    v0 = [v0(:,2) v0(:,1) v0(:,3)];
    vid = ceil(v0);
    vid = sub2ind(size(vent), vid(:,1), vid(:,2), vid(:,3));
    vd = vent(vid);
    
    for iter = 1: 1
        tmp = vd;
        for i = 1: size(f,1)
            if vd(f(i,1)+1,1) == 255 || vd(f(i,2)+1,1) == 255 || vd(f(i,3)+1,1) == 255
                tmp(f(i,:)+1) = 255;
            end
        end
        vd = tmp;
    end
    
    fp = fopen(sprintf('%s.vtk','test'),'w');
    fprintf(fp, '# vtk DataFile Version 3.0\nvtk output\nASCII\nDATASET POLYDATA\n');
    fprintf(fp, 'POINTS %d float\n', size(v, 1));
    fprintf(fp, '%f %f %f\n', v');
    fprintf(fp, 'POLYGONS %d %d\n', size(f, 1), size(f, 1) * 4);
    fprintf(fp, '3 %d %d %d\n', f');
    fprintf(fp, 'POINT_DATA %d\n', size(v, 1));
    fprintf(fp, 'SCALARS SulcalDepth float\nLOOKUP_TABLE default\n');
    fprintf(fp, '%f\n', vd);
    fclose(fp);
end

function [h1, h2, vent] = findTwoHemispheres(vol)
    CC = bwconncomp(vol);
    S = regionprops(CC,'Centroid');

    % largest component
    center = S(1).Centroid;
    center = ceil(center+2);

    % find ventricles
    delta = 1;
    vent = vol;
    vent(:, :, 1: center(2) - delta - 1 +1) = 0;
    vent(:, :, center(2) + delta + 1 +1: end) = 0;
    CC = bwconncomp(vent);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [~,idx] = max(numPixels);
    vol(CC.PixelIdxList{idx}) = 0;  % remove it
    vent(:) = 0;
    vent(CC.PixelIdxList{idx}) = 255;
    
    image_f=vent;
    for slice=center(2) - delta:center(2) + delta
        temp = double(reshape(vent(:,:,slice),size(vent,1),size(vent,2)));
%         image_f(:,:,slice) = conv2(temp,Gaussian,'same');
        image_f(:,:,slice) = imdilate(temp,offsetstrel('ball',3,3));
    end
    vent = (image_f>100)*255;
    
%     figure;
%     for i = 1: 5
%         subplot(3,5,i);imagesc(squeeze(vol(80 + i * 20,:,:))); axis image;
%         subplot(3,5,i+5);imagesc(squeeze(vol(:,80 + i * 20,:))); axis image;
%         subplot(3,5,i+10);imagesc(squeeze(vol(:,:,80 + i * 20))); axis image;
%     end

    % find connected components
    CC = bwconncomp(vol);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [~,idx1] = max(numPixels); numPixels(idx1) = 0;
    [~,idx2] = max(numPixels);
    h1 = CC.PixelIdxList{idx1};
    h2 = CC.PixelIdxList{idx2};
end
