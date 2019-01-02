function separate_hemi(vertices, faces, output1, output2)
    %adjacency matrix is a square matrix used to represent a finite graph.
    W = adjacency(vertices,faces);
    %creates a weighted graph using a square, symmetric adjacency matrix
    G = graph(W);
    %computes the connected components of graph G
    BINS=conncomp(G);
    % Divide vertices
    vert1 = vertices(BINS==1,:);
    vert2 = vertices(BINS==2,:);

    % Get indices based on BINS
    ind1=find(BINS==1);
    ind2=find(BINS==2);

    chk = sum(ismember(faces, ind1),2);

    face1 = faces(chk == 3, :);
    face2 = faces(chk == 0, :);

    tab = zeros(size(vertices,1),1);
    tab(ind1) = 1:length(ind1);
    tab(ind2) = 1:length(ind2);

    face1 = tab(face1);
    face2 = tab(face2);

    write_vtk(vert1,face1,output1);
    write_vtk(vert2,face2,output2);
end
function W = adjacency(X,F)
    % compute weights for all links (euclidean distance)
    if size(F, 2) == 2
        weights = [sum((X(F(:,1),:)-X(F(:,2),:)).^2,2); ...
                   sum((X(F(:,2),:)-X(F(:,1),:)).^2,2)].^0.5;
        rows = [F(:,1); F(:,2)];
        cols = [F(:,2); F(:,1)];
    else
        weights = [sum((X(F(:,1),:)-X(F(:,2),:)).^2,2); ...
                   sum((X(F(:,1),:)-X(F(:,3),:)).^2,2); ...
                   sum((X(F(:,2),:)-X(F(:,1),:)).^2,2); ...
                   sum((X(F(:,2),:)-X(F(:,3),:)).^2,2); ...
                   sum((X(F(:,3),:)-X(F(:,1),:)).^2,2); ...
                   sum((X(F(:,3),:)-X(F(:,2),:)).^2,2)].^0.5;
        rows = [F(:,1); F(:,1); F(:,2); F(:,2); F(:,3); F(:,3)];
        cols = [F(:,2); F(:,3); F(:,1); F(:,3); F(:,1); F(:,2)];
    end
           
    % remove duplicated edges
    [rc,idx] = unique([rows,cols], 'rows','first');
    weights = weights(idx);

    % fill adjacency matrix
    W = sparse(rc(:,1), rc(:,2), weights);
end
function write_vtk(v, f, output)
    fp = fopen(output,'w');
    fprintf(fp, '# vtk DataFile Version 3.0\nvtk output\nASCII\nDATASET POLYDATA\n');
    fprintf(fp, 'POINTS %d float\n', size(v, 1));
    fprintf(fp, '%f %f %f\n', v');
    fprintf(fp, 'POLYGONS %d %d\n', size(f, 1), size(f, 1) * 4);
    fprintf(fp, '3 %d %d %d\n', f'-1);
    fclose(fp);
end
