function[] = VoronoiPropagation()
    %Initial Seeded Random Distribution of Points
    rng default;
    x = 10*rand([1,50]);
    y = 10*rand([1,50]);
    % x = rand([1,10]);
    % y = rand([1,10]);
    P = cat(1,x,y)'; %Create n x 2 array of points

    [centroids,areas,eccentricity,bounded_cells,bounded_nuclei] = VoronoiSurface(P);
    PlotCells(bounded_cells,bounded_nuclei,centroids,P)
end