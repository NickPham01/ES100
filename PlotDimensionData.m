
%% Import and Prepare Data

% Import CSV as a table
DimensionData = readtable('Popular Guitar Pedals_ Characteristics - DimensionData.csv');

% Format the variable names
var_names = table2cell(DimensionData(1,:));
var_names(10) = {'Note'};
DimTable = DimensionData(3:end,:);
DimTable.Properties.VariableNames = var_names

% Convert dimension data to doubles
values = DimTable{:,4:9};
values_size = size(values);
for i = 1:values_size(1)
    for j = 1:values_size(2)
        [i,j];
        mat_val = cell2mat(values(i,j));        % convert cell to matrix (1x1)
        mat_num = str2double(mat_val);          % convert string to double
        if ~isnan(mat_num)                      % If the conversion worked
            mat_val = mat_num;                  % use the double
        elseif contains(mat_val, ',')           % Check if conversion failed because there were 2 numbers
            split = strsplit(mat_val, ', ');
            mat_val = [str2double(cell2mat(split(1))) str2double(cell2mat(split(2)))]; % convert cell to 1x2 double
        else
            mat_val = [0];
        end
        DimTable{i,3+j} = {mat_val};            % load value back into table
    end
end

%% Plot Data as points

figure(1); clf;
xdim_screw = cell2mat(DimTable{:,'X_screw'})
ydim_screw = cell2mat(DimTable{:,'Y_screw'})
scatter(xdim_screw, ydim_screw)

dx = 0.1
dy = 0.1

datalabels = DimTable{:,'Category'}

hold on
text(xdim_screw + dx, ydim_screw + dy, datalabels, 'Interpreter', 'None')
hold off

title('Pedal Bottom Dimensions')
xlabel('X Dimension, in')
ylabel('Y Dimension, in')
%{
hold on
xdim_ext = cell2mat(DimTable{:, 'X_external'})
ydim_ext = cell2mat(DimTable{:, 'Y_external'})

scatter(xdim_ext, ydim_ext)
text(xdim_ext + dx, ydim_ext + dy, datalabels, 'Interpreter', 'None')
hold off

legend('Screw Dimensions', 'External Dimensions', 'Location', 'southeast')
%}

%% Plot Data as Rectangles
figure(2); clf;
xdim_screw = cell2mat(DimTable{:,'X_screw'});
ydim_screw = cell2mat(DimTable{:,'Y_screw'});

xdim_ext = cell2mat(DimTable{:,'X_external'});
ydim_ext = cell2mat(DimTable{:,'Y_external'});

hold on
for i = 1:length(xdim_screw)
    plotRectangle(xdim_screw(i), ydim_screw(i), 0, 1);
    plotRectangle(xdim_ext(i), ydim_ext(i), 1, 0);
end
hold off

%% Determine best fit lines of groupings:

% Look at the first quadrant
% Visually, there is a grouping for x < 1.5 which looks like it could be
% served by one line.  This might be the minimum integer size
% The next four sizes out could be served on the 2x size plate, perhaps in
% two lines.
% The largest one would need to be served by a 3x size perhaps

% Group the rectangles:
group_1x = [];
group_2x = [];
group_3x = [];

for i = 1:length(xdim_screw)
   if xdim_screw(i)/2 < 1.5 && ydim_screw(i) ~= 0
       group_1x = [group_1x i];
   elseif xdim_screw(i)/2 < 4 && ydim_screw(i) ~= 0
       group_2x = [group_2x i];
   elseif ydim_screw(i) ~= 0
       group_3x = [group_3x i];
   end
end

xdim_g1 = xdim_screw(group_1x)/2;
ydim_g1 = ydim_screw(group_1x)/2;

p = polyfit(xdim_g1, ydim_g1, 1)
x_domain = linspace(0, 1.5);
p1 = polyval(p, x_domain);
figure(2)
hold on
scatter(xdim_g1, ydim_g1)
plot(x_domain, p1)
hold off


%% Analyze Data: Use K Means to group data (visually start with 4 groups)










