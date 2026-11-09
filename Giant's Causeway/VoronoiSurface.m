%Creates the surface fracture pattern of a columnar structure system by
%dividing the surface into voronoi polygons.
function[] = VoronoiSurface()
    rng default;
    x = rand([1,10]);
    y = rand([1,10]);
    P = cat(1,x,y)'; %Create n x 2 array of points
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
    voronoi(x,y,'k');
    hold on
    plot(x,y,'r+')
    xlabel("x dimension")
    ylabel("y dimension")
    title("Sample Voronoi Diagram")
    print(gcf,"SampleVoronoiDiagram.png","-dpng")
    %PlotCells(bounded_cells,bounded_nuclei,centroids,x,y);
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

function[] = PlotCells(bounded_cells,bounded_nuclei,centroids,x,y)
    for j = 1:length(bounded_cells)
        current_cell = bounded_cells{j};
        x_coords = current_cell(:,1);
        x_shifted = circshift(x_coords,-1); %Shift elements of x 1 to the left
        x_plot_vals = cat(2,x_coords,x_shifted);

        y_coords = current_cell(:,2);
        y_shifted = circshift(y_coords,-1);
        y_plot_vals = cat(2,y_coords,y_shifted);

        plot(x_plot_vals,y_plot_vals,'k','HandleVisibility','off');
        hold on
    end
    plot(centroids(:,1),centroids(:,2),'bx')
    plot(bounded_nuclei(:,1),bounded_nuclei(:,2),'r+')
    xlim([min(x)-1,max(x)+1])
    ylim([min(y)-1,max(y)+1])
    xlabel("x dimension")
    ylabel("y dimension")
    title("Sample Voronoi Diagram")
    legend('Centroid','Nucleation Site')
    print(gcf,'SampleBoundedVoronoiDiagram.png',"-dpng")
end