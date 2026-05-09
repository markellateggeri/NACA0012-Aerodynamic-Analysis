% Pressure_Cp_15ms_TopBottomLines.m
x = [0.005066667, 0.010133333, 0.012066667, 0.0508, 0.0762, 0.1016, ...
     0.127, 0.1524, 0.253333333, 0.274333333, 0.413333333, 0.396266667, ...
     0.538466667, 0.5182, 0.675666667, 0.640133333, 0.8128, 0.762, ...
     0.9144, 0.8636];

Cp_matrix = [
    0.876279231	0.9493025	0.803255962	0.438139615	-1.095349038	0.073023269	-0.838139615	-0.073023269	-0.730232692	-0.073023269	-0.616046538	0	-0.438139615	0	-0.292093077	-0.073023269	-0.219069808	0.165116346	0.584186154	0.5493025;
    0.963101232	0.963101232	0.740847102	0.740847102	-0.222254131	-0.14816942	-0.488592971	-0.444508261	-0.296338841	-0.14816942	-0.14816942	0	-0.07408471	0.07816942	0.07408471	0.144508261	0.296338841	0.392677681	0.740847102	0.7416854;
    0.985025834	0.833483398	1.060797052	-2.121594105	0.681940962	-1.970051669	0.606169744	-1.363881924	0.151542436	-0.985025834	0.303084872	-0.606169744	-0.075771218	-0.5171218	0	-0.37885609	0.227313654	-0.075771218	0.606169744	0.625025834;
    0.992942956	1.069323183	1.069323183	-0.305520909	0.611041819	-0.687422046	0.534661592	-0.763802274	0.076380227	-0.687422046	-0.039140682	-0.611041819	-0.229140682	-0.546380227	-0.229140682	-0.511041819	0	-0.381901137	0.534661592	0.252942956
    ];

angles = {'-4°','0°','10°','16°'};

% top = odd indices, bottom = even indices
idx_bot = 1:2:length(x);
idx_top = 2:2:length(x);

% fine grids for top and bottom (use each's domain)
xq_top = linspace(min(x(idx_top)), max(x(idx_top)), 300);
xq_bot = linspace(min(x(idx_bot)), max(x(idx_bot)), 300);

figure;
for i = 1:size(Cp_matrix,1)
    Cp_row = Cp_matrix(i,:);
    % top taps
    xtop = x(idx_top);    Cptop = Cp_row(idx_top);
    [xtop_s, itop] = sort(xtop); Cptop_s = Cptop(itop);
    Cptop_smooth = pchip(xtop_s, Cptop_s, xq_top);
    % bottom taps
    xbot = x(idx_bot);    Cpbot = Cp_row(idx_bot);
    [xbot_s, ibot] = sort(xbot); Cpbot_s = Cpbot(ibot);
    Cpbot_smooth = pchip(xbot_s, Cpbot_s, xq_bot);

    ax = subplot(2,2,i); hold(ax,'on'); grid(ax,'on');
    % plot smooth separate lines
    plot(ax, xq_top, Cptop_smooth, '-', 'LineWidth', 1.6, 'Color', [0 0.4470 0.7410]);
    plot(ax, xq_bot, Cpbot_smooth, '-', 'LineWidth', 1.6, 'Color', [0.8500 0.3250 0.0980]);
    % plot original markers for clarity
    plot(ax, xtop_s, Cptop_s, 'o', 'MarkerFaceColor', 'w', 'Color', [0 0.4470 0.7410], 'MarkerSize', 6);
    plot(ax, xbot_s, Cpbot_s, 's', 'MarkerFaceColor', 'w', 'Color', [0.8500 0.3250 0.0980], 'MarkerSize', 6);

    xlabel(ax, 'x/c');
    ylabel(ax, 'C_p');
    ylim([-2.5 1.2])
    title(ax, ['AoA = ' angles{i}]);
    legend(ax, {'top ','bottom ','top ','bottom '}, 'Location', 'best');
    set(ax, 'YDir', 'reverse'); % negatives up
    xlim(ax, [min(x) max(x)]);
    hold(ax,'off');
end

sgtitle('C_p vs x/c per AoA (V = 15 m/s) ');
