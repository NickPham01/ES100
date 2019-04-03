%% SNR Bar Graph 

clear; clc;

% Enter the data
NF_AP       = [-106.793; -106.913; -106.793; -106.913; -107.034; -106.793; -107.034; -107.034; -107.157; -106.793; -107.282; -106.913; -107.034; -107.034; -106.913; -106.913; -107.157; -106.913; -106.913; -106.913];
NF_Direct   = [-96.241; -96.455; -96.205; -96.347; -96.241; -96.17; -96.066; -96.416; -96.101; -96.383; -96.939; -96.683; -96.528; -96.712; -96.491; -95.727; -96.205; -96.383; -96.977; -96.601];
NF_Sum      = [-72.258; -72.296; -72.337; -72.292; -72.263; -72.229; -72.289; -72.323; -72.267; -72.07; -72.112; -72.099; -72.062; -72.044; -72.158; -72.119; -72.051; -72.075; -72.105; -72.064];

% compute statistics
data_NF = [NF_AP NF_Direct NF_Sum];
stats = [mean(data_NF); std(data_NF)]

% get ready for bar graph
barnames = {'AP System'; 'Direct'; 'Summed'};
set(0,'DefaultTextInterpreter', 'latex')

% populate the font data struct
font.TitleSize      = 24;
font.LabelSize      = 18;
font.DataLabelSize  = 12;

% plot data
figure(1); clf;
H_NF_mean = bar(stats(1,:),'BaseValue',stats(1,1));

% set the color of the bars
crimson             = [hex2dec('C9')/hex2dec('FF') 0 hex2dec('16')/hex2dec('FF')];
H_NF_mean.FaceColor = crimson;

ax = gca;

hold on;
% plot the error bars
H_NF_std            = errorbar(stats(1,:), stats(2,:));
H_NF_std.LineStyle  = 'none';
H_NF_std.Color      = [0 0 0];
H_NF_std.LineWidth  = 1;
H_NF_std.CapSize    = 12;

% label the data's numerical values
data_labels = {'1'; '2'; '3'};
for i = 1:3
    data_labels{i} = strcat(sprintf('%2.1f \n$', stats(1,i)), '$\sigma = $', sprintf('%2.1f', stats(2,i)));
end
H_text = text(1:3, stats(1,:)+0.5, data_labels, 'vert','bottom','horiz','center', 'FontSize', font.DataLabelSize);


% insert the bar names
H_xlabels = text(1:3, ones(1,3) + ax.YLim(1) - 4.5, barnames, 'vert','bottom','horiz','center', 'FontSize', font.DataLabelSize);

% insert the yticks
H_ylables = text(ones(1,size(ax.YTick, 2)) - 1.5, ax.YTick, num2str(ax.YTick'));

hold off;



% move the xlabel down and ylabel left, to leave space for the tick labels
vec_pos = get(get(ax, 'XLabel'), 'Position');
set(get(ax, 'XLabel'), 'Position', vec_pos + [0 -0.5 0]);
vec_pos = get(get(ax, 'YLabel'), 'Position');
set(get(ax, 'YLabel'), 'Position', vec_pos + [0.05 5 0]);

% set the axis, title labels
ax.XTickLabel   = [];
ax.YTickLabel   = [];
xlabel('Signal Path');
ylabel('Noise Floor (dBu)');
title('\textbf{Noise Floor Data}');
ax.YLim         = [-110, -60];

ax.Title.FontSize   = font.TitleSize;
ax.XLabel.FontSize  = font.LabelSize;
ax.YLabel.FontSize  = font.LabelSize;

% save figure
saveas(gcf, 'FinalImages/SNR_bargraph.png')

%% 
set(0,'DefaultTextInterpreter', 'tex')

time2sum = [514;633;435;639;517;513;437;533;509;675;631;519;563;669;639;325;481;499;629;337;];
timefromsum = [455;447;467;489;467;459;41;499;59;519;479;79;487;465;525;473;459;489;485;459;];

data_switchtime = [time2sum timefromsum]

stats_switch = [mean(data_switchtime); std(data_switchtime)]

figure(2);clf;

H_FR_mean = bar(stats_switch(1,:));
hold on;
H_error = errorbar(1:2, stats_switch(1,:), stats_switch(2,:));
H_error.LineStyle = 'none'
hold off;

% set the color of the bars
crimson             = [hex2dec('C9')/hex2dec('FF') 0 hex2dec('16')/hex2dec('FF')];
H_FR_mean.FaceColor = crimson;
H_error.Color       = [0 0 0];
H_error.CapSize     = 12;

ax = gca;

ax.XTickLabel = {'To Sum'; 'From Sum'};

xlabel('Relay Switching Direction');
ylabel('Switching Time (us)');
title('Relay Switching Time');

% save figure
saveas(gcf, 'FinalImages/Switch_bargraph.png')























