function[] = PlotCells(bounded_cells,bounded_nuclei,centroids,P)
    PlottingDefaults;
    x = P(:,1);
    y = P(:,2);
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
    %print(gcf,'SampleBoundedVoronoiDiagram.png',"-dpng")
end