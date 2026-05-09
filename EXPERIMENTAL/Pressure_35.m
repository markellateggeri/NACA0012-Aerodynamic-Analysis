% Pressure_Cp_35ms_SeparatedTopBottom.m
% One subplot per AoA, separate smooth lines for top and bottom (V = 35 m/s)

x = [0.005066667, 0.010133333, 0.012066667, 0.0508, 0.0762, 0.1016, ...
     0.127, 0.1524, 0.253333333, 0.274333333, 0.413333333, 0.396266667, ...
     0.538466667, 0.5182, 0.675666667, 0.640133333, 0.8128, 0.762, ...
     0.9144, 0.8636];

Cp_matrix = [
    0.95598076	1.054390544	0.745102651	0.562341624	-1.223678437	0.168702487	-0.983219733	0.042175622	-0.759161192	0.0196819568	-0.610878109	-0.028117081	-0.435814758	-0.014058541	-0.309287893	-0.028117081	-0.132761028	0.295229352	0.762634327 0.846273463;
    0.978477648	1.034390657	0.824716875	0.293543294	0.136542892	-0.055913008	-0.0489238824	-0.151717278	-0.1684934354	-0.167956504	-0.14569553	-0.153760773	-0.1093434555	-0.129891261	-0.01558679	-0.097847765	0.167739025	0.111608538	0.805043093	0.8306434152;
   1.00356232	0.529657891	1.017500686	-1.923494447	0.673904429	-1.365959825	0.446027698	-1.226267997	0.141815097	-0.742979912	0.129075483	-0.641164816	-0.069691828	-0.452705677	-0.055753462	-0.362397504	0.355753462	-0.097568559	0.78722645	0.589623955;
   0.997855409	0.838591029	1.025573615	-1.872356729	0.734532454	-1.689401583	0.651377837	-1.463092349	0.235604749	-0.942418998	0.154900264	-0.734532454	0.013859103	-0.577182058	-0.013859103	-0.360336676	0.269295515	0.030872823	0.623659631	0.4711714512;
    ];

angles = {'-2°','0°','10°','14°'};

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

sgtitle('C_p vs x/c per AoA (V = 35 m/s)');
