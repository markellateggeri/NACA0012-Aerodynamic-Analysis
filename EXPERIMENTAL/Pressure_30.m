% Pressure_Cp_30ms_SeparatedTopBottom.m
% One subplot per AoA, separate smooth lines for top and bottom (V = 30 m/s)

x = [0.005066667, 0.010133333, 0.012066667, 0.0508, 0.0762, 0.1016, ...
     0.127, 0.1524, 0.253333333, 0.274333333, 0.413333333, 0.396266667, ...
     0.538466667, 0.5182, 0.675666667, 0.640133333, 0.8128, 0.762, ...
     0.9144, 0.8636];

Cp_matrix = [
    1.023592816	1.042548239	0.928815704	-0.094777113	-0.173885563	-0.379108451	-0.360598803	-0.454930141	-0.444930141	-0.462687958	-0.377910845	-0.384331338	-0.30328676	-0.294777113	-0.22746507	-0.190598803	-0.10164338	-0.08509648	0.644484366	0.733592816;
    1.014115156	0.826316053	1.014115156	-0.920215605	0.481459372	-1.014115156	0.225358924	-0.957775425	0.030239282	-0.563397309	0.091459372	-0.450717847	0.045239282	-0.320239282	0.112679462	-0.262918744	0.75119641	0.150239282	1.13851695	1.014115156;
   1.019514761	0.528637284	1.038394664	-1.982389814	0.709757381	-1.415992724	0.490877478	-1.340473112	0.075519612	-0.75519612	0.036558836	-0.641916702	-0.056639709	-0.445438739	-0.056639709	-0.358718157	0.356639709	-0.132159321	0.641916702	0.549514761;
    1.010011573	0.857556996	1.029068395	-0.762272885	0.714534198	-1.048125217	0.495477375	-1.048125217	0.116227289	-0.876613818	0.159625043	-0.876613818	0.114340933	-0.738306909	0.152454577	-0.686045597	0.528681866	-0.152454577	1.352647842	0.890954751;
    ];

angles = {'0°','6°','10°','16°'};

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

sgtitle('C_p vs x/c per AoA (V = 30 m/s)');
