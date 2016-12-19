function plotValues(value, titleText, symbols)
    customColorMap = zeros(128, 3);
    
    % 238,130,238 (Violet)
    customColorMap(:, 1) = linspace(1, 238 / 256, 128);
    customColorMap(:, 2) = linspace(1, 130 / 256, 128);
    customColorMap(:, 3) = linspace(1, 238 / 256, 128);
    
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
            if exist('symbols', 'var') 
                textHandles(j,i) = text(j, i, char(symbols{value(i,j) + 1}), 'horizontalAlignment', 'center', 'Color', 'black', 'FontSize', 9, 'FontWeight', 'bold');
            else
                textHandles(j,i) = text(j, i, num2str(value(i,j)), 'horizontalAlignment', 'center', 'Color', 'black', 'FontSize', 9, 'FontWeight', 'bold');
            end
        end
    end

    %tightfig();
    %print('confMat.png', '-dpng');
end