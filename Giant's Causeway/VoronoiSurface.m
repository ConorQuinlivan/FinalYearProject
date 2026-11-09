%Creates the surface fracture pattern of a columnar structure system by
%dividing the surface into voronoi polygons.
function[centroids,areas,eccentricity,bounded_cells,bounded_nuclei] = VoronoiSurface(P)
    [vertices,cells] = voronoin(P); %Returns vertices and cells of voronoi diagram
    
    [bounded_cells, bounded_nuclei] = FindBoundedCells(P,vertices,cells);
    [centroids, areas] = FindPgonCharacteristics(bounded_cells);
    eccentricity = sqrt(dot(bounded_nuclei-centroids,bounded_nuclei-centroids,2));
    avg_ecc = mean(eccentricity);
    
    mean_area = mean(areas);
    median_area = median(areas);
    stddev_area = std(areas);
    %Plot area distribution
    
    PlottingDefaults
    
    % voronoi(x,y,'k');
    % hold on
    % plot(x,y,'r+')
    % xlabel("x dimension")
    % ylabel("y dimension")
    % title("Sample Voronoi Diagram")
    % %print(gcf,"SampleVoronoiDiagram.png","-dpng")
end

function[bounded_cells,bounded_nuclei] = FindBoundedCells(P,vertices,cells)
    bounded_cells = {};
    bounded_nuclei = zeros(size(P));
    for i = 1:length(cells)
        if all(cells{i} ~= 1) %If cell does not contain row 1 of v it is bounded
            bounded_cells{end+1} = vertices(cells{i},:);
            bounded_nuclei(i,:) = P(i,:);
        end
    end
    [row, col] = find(bounded_nuclei == 0);
    idx1 = ceil(length(row)/2)+1;
    idx = idx1:length(row);
    row(idx) = [];
    bounded_nuclei(row,:) = [];
end

function[centroids, areas] = FindPgonCharacteristics(bounded_cells)
    centroids = zeros(numel(bounded_cells),2);
    areas = zeros(numel(bounded_cells),1);
    for i = 1:numel(bounded_cells)
        pgon = polyshape(bounded_cells{i},'Simplify',false);
        [Cx, Cy] = centroid(pgon);
        areas(i) = area(pgon);
        centroids(i,:) = [Cx, Cy];
    end
end