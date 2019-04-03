%% SNR
% SNR Test01 data
snrtest01 = readtable("NickPhamAPMeasurements/APSystemTHD_01.csv")
figure(1); clf;

% conver table to list of strings
sendLevel   = string(snrtest01.Gen_Ampl);
returnLevel = string(snrtest01.Anlr_LevelA);

% remove non numeric values
nonNumIDX = strcmp(sendLevel, "") | strcmp(sendLevel, "dBu") | contains(sendLevel, "Source");
sendLevel(nonNumIDX) = []
returnLevel(nonNumIDX) = []


%% FR

FRtest  = readtable("NickPhamAPMeasurements/DeviceActiveChoke_FR.csv");
Freq    = string(FRtest.Gen_Freq);
level   = string(FRtest.Anlr_LevelA);

Freq(1:2) = [];
level(1:2) = [];

for i = 1:max(size(Freq))
    f(i) = str2num(Freq(i));
    l(i) = str2num(level(i));
end
figure(2);clf;
inputMeasurement = semilogx(f, l)

xlim_min = 10;
xlim_max = 30000;
xlim([xlim_min xlim_max]);

ylim([-0.5 0.5])

title("Frequency Response")
xlabel("Frequency (Hz)")
ylabel("Measured Response to 0dBu Sinusoid (dBu)")

% show output signal for comparison
outputRef = refline(0,0); outputRef.LineStyle = '--'; outputRef.Color = 'black';

% show goal for reference
Xref = [xlim_min, xlim_max, xlim_max, xlim_min];
Yref = [-0.1 -0.1 0.1 0.1];
goal = patch(Xref, Yref, "blue", 'EdgeColor', 'none')
alpha(goal, 0.1)

legend([outputRef, inputMeasurement, goal], [{'Reference 0dBu Output Signal'}, {'Measured Signal in dBu'}, {'0.1 dBu Flatness Goal'}])

%% FR now in black


% plot these as a multiple bar graph
figure('Color',[0 0 0],'InvertHardcopy','off');
set(gcf,'units','normalized','outerposition',[0 0 0.6 1]);

%figure(1);clf;
semilogx(f,l, 'LineWidth', 10)
ax = gca;

set(gca, 'Color', [0 0 0]);

font.size = 36;
font.wt = 'bold';
font.color = 'w';
font.name = 'Helvetica';

ax.TitleFontSizeMultiplier = 2;
ax.XColor = [1 1 1];
ax.YColor = [1 1 1];
ax.XAxis.FontSize = font.size;
ax.YAxis.FontSize = font.size;
ax.XAxisLocation = 'bottom';
ax.YAxisLocation = 'left';

xlim_min = 10;
xlim_max = 30000;
xlim([xlim_min xlim_max]);
ylim([-0.5 0.5]);


xlabel('Frequency (Hz)', ...
    'FontSize', font.size, 'FontWeight', font.wt, 'Color', font.color, 'FontName', font.name)
ylabel('Magnitude (dBu)', ...
    'FontSize', font.size, 'FontWeight', font.wt, 'Color', font.color, 'FontName', font.name)
title({'Direct Frequency Response'}, ...
    'FontSize', font.size, 'FontWeight', font.wt, 'Color', font.color, 'FontName', font.name)


% show output signal for comparison
outputRef = refline(0,0); outputRef.LineStyle = '--'; outputRef.Color = 'w'; outputRef.LineWidth = 5;

% show goal for reference
Xref = [xlim_min, xlim_max, xlim_max, xlim_min];
Yref = [-0.1 -0.1 0.1 0.1];
goal = patch(Xref, Yref, "w", 'EdgeColor', 'none')
alpha(goal, 0.5)



legend({'Measured Signal', 'Reference 0 dBu Signal', '0.1 dBu Flatness Goal'}, ...
    'FontSize', 20, 'TextColor', font.color, 'FontWeight', font.wt, 'Location', 'northeast')
legend boxoff
















































