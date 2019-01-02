function tri = circle_patch(nbPts)
    %% http://l2program.co.uk/900/concentric-disk-sampling
    nbPts = nbPts - 1;
    nPts = 50;
    nPts2 = 50;
    r = 1 - 1 / nPts;
    R1 = 0: r / nPts: r;
    R2 = 0: r / nPts2: r;

    radius = ones(1,(nPts+1)*(nPts2+1)) * r;
    phi = zeros(1,(nPts+1)*(nPts2+1));
    a = (2 * R1) - r;
    b = (2 * R2) - r;
    a = repelem(a, 1, nPts2+1);
    b = repmat(b, 1, nPts+1);
    upper = a.*a > b.*b;
    lower = ~upper;

    radius(upper)  = radius(upper) .* a(upper);
    phi(upper) = (b(upper)./a(upper)) * (pi/4);

    radius(lower)  = radius(lower) .* b(lower);
    phi(lower) = (pi/2) - ((pi/4) * (a(lower)./b(lower))); 

    phi(isnan(phi)) = 0;

    x = cos(phi) .* radius;
    y = sin(phi) .* radius;

    bphi = (0: nbPts) * 2 * pi / nbPts;
    x = [x cos(bphi)];
    y = [y sin(bphi)];
    z = ones(1,(nPts + 1)*(nPts+1) + nbPts+1)*0;
    tri = delaunayTriangulation(x',y');
%     tri = delaunay(x,y);
%     trisurf(tri,x,y,z);
%     axis equal square;

    % figure; hold on;
    % scatter(x,y);
    % hold off;
    % axis equal square;
end