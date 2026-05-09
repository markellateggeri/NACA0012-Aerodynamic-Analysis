% Pressure_Cp_25ms_SeparatedTopBottom.m
% One subplot per AoA, separate smooth lines for top and bottom (V = 25 m/s)

x = [0.005066667, 0.010133333, 0.012066667, 0.0508, 0.0762, 0.1016, ...
     0.127, 0.1524, 0.253333333, 0.274333333, 0.413333333, 0.396266667, ...
     0.538466667, 0.5182, 0.675666667, 0.640133333, 0.8128, 0.762, ...
     0.9144, 0.8636];

Cp_matrix = [
    1.003118945	1.057341591	0.894673654	0.298224551	-0.813339685	-0.108445291	-0.712447197	-0.216890583	-0.596449102	-0.135556614	-0.528445291	-0.135556614	-0.406669843	-0.027111323	-0.244001906	-0.041333969	-0.095556614	0.271113228	0.623560425	0.700230268;
    1.035998392	1.063261508	0.954209046	-0.054526231	-0.156209849	-0.381683618	-0.369052462	-0.436209849	-0.396209849	-0.426315578	-0.3232416	-0.37536804	-0.272631156	-0.321789347	-0.170841809	-0.223578694	0.133578694	-0.108104925	0.68157789	0.408735277;
    0.715998392	0.68157789	1.035998392	-1.85389186	0.697999196	-1.390418895	0.490736081	-1.278629548	0.259052462	-0.7208946734	0.182631156	-0.599788543	0.154526231	-0.380841809	0.27263116	-0.327157387	0.437263116	-0.073578694	0.68157789	0.585998392;
    0.933118945	0.894673654	1.003118945	-0.406669843	0.688003811	-0.704894394	0.460892488	-0.732005717	0.23111323	-0.677783071	0.18977926	-0.650671748	0.166890583	-0.591113228	0.211113228	-0.574894394	0.4206669843	-0.244001906	0.730892488	0.576007622;
    ];

angles = {'-2°','0°','8°','15°'};

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

sgtitle('C_p vs x/c per AoA (V = 25 m/s)');
