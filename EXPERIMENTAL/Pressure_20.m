% Pressure_Cp_20ms_SeparatedTopBottom.m
% One subplot per AoA, separate smooth lines for top and bottom (V = 20 m/s)

x = [0.005066667, 0.010133333, 0.012066667, 0.0508, 0.0762, 0.1016, ...
     0.127, 0.1524, 0.253333333, 0.274333333, 0.413333333, 0.396266667, ...
     0.538466667, 0.5182, 0.675666667, 0.640133333, 0.8128, 0.762, ...
     0.9144, 0.8636];

Cp_matrix = [
    0.967366212	1.009425613	0.925306812	-0.084118801	-0.420594005	-0.420594005	-0.494118801	-0.462653406	-0.420594005	-0.378534605	-0.3342647	-0.294415804	-0.266475204	-0.224118801	-0.210297003	-0.168237602	-0.030297003	0.042356403	0.410891008	0.395306812;
    0.677484867	0.635928042	1.017484867	-2.016526559	0.635928042	-1.541436895	0.551137636	-1.441436895	0.237185608	-1.017484867	0.094371217	-0.678323245	-0.084790406	-0.519580811	-0.042395203	-0.381556825	0.635089664 -0.084790406	0.8859580811	0.635928042;
    1.009425613	1.009425613	1.009425613	-0.336475204	0.584712806	-0.672950408	0.462653406	-0.715009809	0.082059401	-0.672950408	-0.068237602	-0.588831607	-0.110297003	-0.550297003	-0.124415804	-0.500891008	0.068534605	-0.378237602	0.504712806	0.157366212;
    1.021550736	1.021550736	1.021550736	-0.340516912	0.650775368	-0.681033824	0.510775368	-0.723598438	0.242564614	-0.681033824	0.030258456	-0.63846921	-0.035387684	-0.58282307	-0.067952298	-0.551033824	0.02564614	-0.270258456	0.468210754	0.178986122;
    ];

angles = {'0°','10°','14°','16°'};

% Indices: top = odd taps, bottom = even taps
idx_bot = 1:2:length(x);
idx_top = 2:2:length(x);

% Sorted x and permutations for each set
[x_top_sorted, p_top] = sort(x(idx_top));
[x_bot_sorted, p_bot] = sort(x(idx_bot));

% Fine grids for smoothing
xq_top = linspace(min(x_top_sorted), max(x_top_sorted), 300);
xq_bot = linspace(min(x_bot_sorted), max(x_bot_sorted), 300);

figure;
colors = lines(size(Cp_matrix,1));

for i = 1:size(Cp_matrix,1)
    Cp = Cp_matrix(i,:);
    Cp_top = Cp(idx_top); Cp_bot = Cp(idx_bot);
    Cp_top_sorted = Cp_top(p_top);
    Cp_bot_sorted = Cp_bot(p_bot);

    Cp_top_smooth = pchip(x_top_sorted, Cp_top_sorted, xq_top);
    Cp_bot_smooth = pchip(x_bot_sorted, Cp_bot_sorted, xq_bot);

    ax = subplot(2,2,i);
    hold(ax,'on'); 
    grid(ax,'on');
    plot(ax, xq_top, Cp_top_smooth, '-', 'Color', colors(i,:), 'LineWidth', 1.6);
    plot(ax, xq_bot, Cp_bot_smooth, '--', 'Color', colors(i,:), 'LineWidth', 1.6);
    plot(ax, x_top_sorted, Cp_top_sorted, 'o', 'Color', colors(i,:), 'MarkerFaceColor','w', 'MarkerSize',6);
    plot(ax, x_bot_sorted, Cp_bot_sorted, 's', 'Color', colors(i,:), 'MarkerFaceColor','w', 'MarkerSize',6);

    xlabel(ax, 'x/c');
    ylabel(ax, 'C_p');
    ylim([-2.5 1.2])
    title(ax, ['AoA = ' angles{i}]);
    legend(ax, {'top ','bottom ','top (data)','bottom (data)'}, 'Location','best');
    set(ax, 'YDir', 'reverse'); % aerodynamic convention
    xlim(ax, [min(x) max(x)]);
    hold(ax,'off');
end

sgtitle('C_p vs x/c per AoA (V = 20 m/s)');
