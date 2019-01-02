function stitch(volname, surfname, out1, out2)
    fprintf('volume separation\n');
    [vd, v, f] = separate_vol(volname, surfname);
    f = f+1;
    bdry = find(vd == 255);

    % pre-computed index
    fprintf('index table\n');
    [invalid_f,fid]=computeIndex(v,f,bdry);
    
    % graph
    fprintf('boundary computation\n');
    [tr1, tr2] = getBoundary(v,f,fid);

    % delaunay triangulation
    fprintf('patch creation\n');
    [pv1,pf1,k1] = circlePatch(tr1);
    [pv2,pf2,k2] = circlePatch(tr2);

    % poisson
    fprintf('optimization\n');
%     x=poisson_(v,pv,pf,tr1,k,connectivity(v,f),connectivity(pv,pf));
    x=[poisson(v,pv1,pf1,tr1,k1);poisson(v,pv2,pf2,tr2,k2)];
    
    % stitch
    fprintf('stitching\n');
    tr=[tr1 tr2];
    base = max(pf1(:));
    pf = [pf1;pf2+base];
    k = [k1;k2+base];
    [vnew,fnew,id,pf0]=closeSurface(x,v,f,invalid_f,k,tr,pf,fid);

    % boundary smoothing
    fprintf('boundary smoothing\n');
    nnv = connectivity(vnew,fnew);

    list = unique([id(tr); unique(id(pf0))]);
    fid = neighborFace(vnew,fnew);
    for i = 1: 1
        list = union(list,unique(fnew(horzcat(fid{list}),:)));
    end
    vnew0 = smooth(vnew,nnv,15,list);

    % output
%     writeVTK('output.vtk', vnew0, fnew, id(tr1), id(tr2));
%     writePatch('patch.vtk',x,pf);

    % separation
    fprintf('writing output files\n');
    separate_hemi(vnew0,fnew,out1,out2);
end

function [tr1, tr2] = getBoundary(v,f,fid)
    pid = find(~cellfun(@isempty,fid(:,1)) & cellfun(@nnz,fid(:,2)));

    visited = zeros(size(v,1),1) == 1;
    src = pid(1);

    tr1 = [];
    while ~visited(pid(1))
        nf = fid{src,1};
        for i = 1: length(nf)
            nv = f(nf(i), [1 2 3 1]);
            nv = nv(find(nv(1:3)==src) + 1);
            if ~visited(nv) & ismember(nv, pid)
                visited(nv) = 1;
                src = nv;
                tr1 = [tr1 src];
            end
        end
    end

    src = pid(find(~visited(pid),1));
    tr2 = [];
    while ~visited(pid(find(~visited(pid),1)))
        nf = fid{src,1};
        for i = 1: length(nf)
            nv = f(nf(i), [1 2 3 1]);
            nv = nv(find(nv(1:3)==src) + 1);
            if ~visited(nv) & ismember(nv, pid)
                visited(nv) = 1;
                src = nv;
                tr2 = [tr2 src];
            end
        end
    end

    tr1=tr1(end:-1:1);
    tr2=tr2(end:-1:1);
end
function nnv = connectivity(v,f)
    nnv = cell(size(v, 1), 1);
    for i = 1: size(f, 1)
        nnv{f(i,1)} = [nnv{f(i,1)}, f(i, 2: 3)];
        nnv{f(i,2)} = [nnv{f(i,2)}, f(i, 1:2:3)];
        nnv{f(i,3)} = [nnv{f(i,3)}, f(i, 1: 2)];
    end
    for i = 1: size(v, 1)
        nnv{i} = unique(nnv{i});
    end
end
function v0 = smooth(v,nnv,maxIter,list)
    v0=v;
    for iter=1:maxIter
        tmp = v0;
        for i = 1: size(list,1)
            tmp(list(i),:)=mean(v0(nnv{list(i)},:));
        end
        v0=tmp;
    end
end
function [pv,pf,k]=circlePatch(tr1)
    DT = circle_patch(length(tr1));
    k = convexHull(DT);
    k = k(1:end-1);
    pf = DT.ConnectivityList;
    pv = DT.Points;
end
function [invalid_f,fid]=computeIndex(v,f,bdry)
    invalid_f = [];
    for i = 1: size(f,1)
        if ~isempty(find(bdry==f(i,1), 1)) && ~isempty(find(bdry==f(i,2),1)) && ~isempty(find(bdry==f(i,3),1))
            invalid_f=[invalid_f i];
        end
    end

    fid = neighborFace(v,f);

    for i = 1: size(fid,1)
        [c, ia] = setdiff(fid{i,1},invalid_f);
        fid(i,2)={length(fid{i,1})-length(ia)};
        fid(i,1)={c};
    end
end
function x=poisson(v,pv,pf,tr1,k)
    % graph laplacian
    A = sparse(length(pv),length(pv));
    for i = 1: size(pf,1)
        A(pf(i,1),pf(i,2))=-1;
        A(pf(i,2),pf(i,1))=-1;

        A(pf(i,2),pf(i,3))=-1;
        A(pf(i,3),pf(i,2))=-1;

        A(pf(i,3),pf(i,1))=-1;
        A(pf(i,1),pf(i,3))=-1;
    end
    A = A - sparse(diag(full(sum(A)),0));
    b = zeros(length(pv), 3);
    for i = 1: size(k)
        b(k(i),:) = v(tr1(i), :);
        A(k(i),:) = 0;
        A(k(i),k(i)) = 1;
    end
    x = A \ b;
end

function x=poisson_(v,pv,pf,tr1,k,nnv,neighbor)
    % graph laplacian
    A = sparse(length(pv),length(pv));
    for i = 1: size(pf,1)
        A(pf(i,1),pf(i,2))=-1;
        A(pf(i,2),pf(i,1))=-1;

        A(pf(i,2),pf(i,3))=-1;
        A(pf(i,3),pf(i,2))=-1;

        A(pf(i,3),pf(i,1))=-1;
        A(pf(i,1),pf(i,3))=-1;
    end
    A = A - sparse(diag(full(sum(A)),0));
    % boundary condition
    b = zeros(size(pv,1), 3);
    % for i = 1: size(pv,1)
    %     b(i,1:2) = sum(pv(neighbor{i}', :) - repmat(pv(i,:), length(neighbor{i}),1));
    % end
    for i = 1: size(k)
        nid = ismember(k,neighbor{k(i)});
        A(k(i),setdiff(k, k(i))) = 0;
        b(k(i),:) = b(k(i),:)+sum(v(tr1(nid), :));
        % grad of cortical surface
        nn = nnv{tr1(i)}(~invalid_v(nnv{tr1(i)}));
        grad = sum(v(nn,:)-repmat(v(tr1(i),:),length(nn),1));
        % grad of patch
        nn = tr1(ismember(nnv{tr1(i)},tr1));
        vv = v(nn,:)-repmat(v(tr1(i),:),length(nn),1);
        alpha=0.5;
        grad = grad + vv(2,:) * alpha + vv(1,:) * (1-alpha);
        b(k(i),:) = b(k(i),:)-grad;
    end
    x = A \ b;
end
function [vnew,fnew,id,pf0]=closeSurface(x,v,f,invalid_f,k,tr1,pf,fid)
    v0 = [v; x];
    basef = max(f(:));
    pf0=pf+double(basef);
    for i = 1: size(k,1)
        pf0(pf == k(i)) = tr1(i);
    end
    f0 = [f; pf0];

    invalid_v = cellfun(@isempty,fid(:,1));
    invalid_v = [invalid_v; zeros(size(x,1),1)];
    invalid_v(double(basef)+k) = 1;
    vid = [1:size([v;x],1)]';
    vid(invalid_v==1) = [];
    id = [1:size([v;x],1)]';
    id(vid)=1:size(vid,1);
    vnew = v0(~invalid_v,:);

    fnew = f0;
    fnew(invalid_f, :)=[];
    fnew=id(fnew);
end
function fid=neighborFace(vnew,fnew)
    fid = cell(size(vnew,1),2);
    for i = 1:size(fnew,1)
        fid(fnew(i,1)) = {[fid{fnew(i,1)} i]};
        fid(fnew(i,2)) = {[fid{fnew(i,2)} i]};
        fid(fnew(i,3)) = {[fid{fnew(i,3)} i]};
    end
end

function writeVTK(output, v, f, tr1, tr2)
    vd = zeros(size(v,1),1);
    vd(tr1) = 100:100+length(tr1)-1;
    vd(tr2) = 100:100+length(tr2)-1;
    fp = fopen(output,'w');
    fprintf(fp, '# vtk DataFile Version 3.0\nvtk output\nASCII\nDATASET POLYDATA\n');
    fprintf(fp, 'POINTS %d float\n', size(v, 1));
    fprintf(fp, '%f %f %f\n', v');
    fprintf(fp, 'POLYGONS %d %d\n', size(f, 1), size(f, 1) * 4);
    fprintf(fp, '3 %d %d %d\n', f'-1);
    fprintf(fp, 'POINT_DATA %d\n', size(v, 1));
    fprintf(fp, 'SCALARS Scalar float\nLOOKUP_TABLE default\n');
    fprintf(fp, '%f\n', vd);
    fclose(fp);
end
function writePatch(output,x,pf)
    fp = fopen(output,'w');
    fprintf(fp, '# vtk DataFile Version 3.0\nvtk output\nASCII\nDATASET POLYDATA\n');
    fprintf(fp, 'POINTS %d float\n', size(x, 1));
    fprintf(fp, '%f %f %f\n', x');
    fprintf(fp, 'POLYGONS %d %d\n', size(pf, 1), size(pf, 1) * 4);
    fprintf(fp, '3 %d %d %d\n', pf'-1);
    fclose(fp);
end
