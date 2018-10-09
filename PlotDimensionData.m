
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
xdim_screw = cell2mat(DimTable{:,'X_screw'})
ydim_screw = cell2mat(DimTable{:,'Y_screw'})

hold on
for i = 1:length(xdim_screw)
    plotRectangle(xdim_screw(i), ydim_screw(i), 0, 1)
end
hold off


%% Analyze Data: Use K Means to group data (visually start with 4 groups)










