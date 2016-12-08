function plotValues(value, titleText)
    % customColorMap = [1, 1, 1; 0.5, 0, 0.5];
    customColorMap = zeros(128, 3);
    customColorMap(:, 1) = linspace(1, 1, 128);
    customColorMap(:, 2) = linspace(1, 0, 128);
    customColorMap(:, 3) = linspace(1, 0, 128);

    figure;
    imagesc(value);
    % colormap customColorMap;
    colormap(customColorMap);
    title(titleText);
    set(gca,'XTick', []);
    set(gca,'YTick', []);

    % Add intensity values
    [rows,cols] = size(value);
    for i = 1:rows
        for j = 1:cols
            textHandles(j,i) = text(j, i, num2str(value(i,j)), 'horizontalAlignment', 'center', 'Color', 'black', 'FontSize', 9, 'FontWeight', 'bold');
        end
    end

    %tightfig();
    %print('confMat.png', '-dpng');
end