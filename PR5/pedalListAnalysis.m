%% Import Data
clear;
clc;

data = readtable('guitarPedalList.csv');
dimdata = readtable('DimensionData.csv');


%% Convert Company Names into Numbers and Count Number of Products

% Create array of company and number for the companies in data
companies = array2table(zeros(1,3), 'VariableNames', {'CompanyName' 'ID' 'ProductCount'});
companies.CompanyName = "";

% For each pedal in the data table
companylist = string(data{:,1});                                    % convert company name to string
for idx = 1:length(data{:,1})
    company = strtrim(companylist(idx));
    if ~ismember(company, companies{:,1}) & ~strcmp(company,"")         % If the company is not yet accounted for
        companies = [companies; {company, size(companies,1), 1}];                    %   append it to the end of the table
    elseif ismember(company, companies{:,1}) & ~strcmp(company,"")     % If the company is already in the table
        company_idx = find(companies{:,1} == company);              %   find what its assigned number is            
        companies{company_idx, 3} = companies{company_idx, 3} + 1;  %   increment the number of products for that company
    end
end
companies([1],:) = []                   % get rid of the first row

% Bar Plot of Pedals Offered Per Manufacturer 
figure(1);clf;
bar(companies.ID, companies.ProductCount)
xlabel("Company ID Number")
ylabel("Number of Products Available")
title("Pedals Available by Company")

%% Convert Pedal Enclosure Types into Numerical Table
enclosures = array2table(zeros(1,7), 'VariableNames', {'EnclosureName' 'ID' 'Company' 'ProductCount' 'x' 'y' 'diag'});
enclosures.EnclosureName = "";

% For each pedal in the data table
enclosureList = string(data{:,3})                                    % convert enclosure name to string
for idx = 1:length(data{:,3})
    enclosure = strtrim(enclosureList(idx));
    
    if ~ismember(enclosure, enclosures{:,1}) & ~strcmp(enclosure,"")         % If the enclosure is not yet accounted for        
        cName = strtrim(string(data{idx,1}));                               % determine which company produces this enclosure type
        companyID = companies.ID(companies.CompanyName == cName);
        x_dim = dimdata.X_external(dimdata.Category == enclosure);
        y_dim = dimdata.Y_external(dimdata.Category == enclosure);
        if isempty(x_dim) | strcmp(x_dim, '')
            x_dim = NaN;
            y_dim = NaN;
            diag = NaN;
        else
            x_dim = str2num(x_dim{1});
            y_dim = str2num(y_dim{1});
            screw_scaling_factor = 0.95;
            diag = sqrt((x_dim*screw_scaling_factor)^2 + (y_dim*screw_scaling_factor)^2);
        end
        
        enclosures = [enclosures; {enclosure, size(enclosures,1), companyID, 1, x_dim, y_dim, diag}];                    %   append it to the end of the table
        
    elseif ismember(enclosure, enclosures{:,1}) & ~strcmp(enclosure,"")     % If the enclosure is already in the table
        enclosure_idx = find(enclosures{:,1} == enclosure);              %   find what its assigned number is            
        enclosures{enclosure_idx, 4} = enclosures{enclosure_idx, 4} + 1;  %   increment the number of products for that enclosure
    end
end
enclosures([1],:) = []                   % get rid of the first row


%% Plot Enclosure and Company Data
% Stacked Bar Plot of Pedal Types Available by Manufacturer
% first make array of manufacturers
x = zeros(height(companies), height(enclosures));
%{
for i = 1:height(enclosures)
    % i is the enclosureID
    c = enclosures.Company(i);
    x(c,i) = enclosures.ProductCount(i);
end
%}

for i = 1:size(x,1)
    % enclosures by company i
    e = enclosures.ProductCount(enclosures.Company == i);
    
    x(i:i+size(e,2)-1,1:size(e,1)) = sort(e, 'descend');
end

% Show by company
figure(2);clf;
bar(x, 'stacked')
xlabel("Company ID Number")
ylabel("Number of Products Available")
title({"Pedals Available by Company,", "Subdivided Vertically by Enclosure Type"})
saveas(3, 'PR4Images/PedalsAvailable.jpg')



%% How many pedals fit using other metrics?
%{
    - does the supply voltage contain 9V, 12V, 18V?
    - does the pedal have only one input and output
    - are the pedal's dimensions compatible with the current receiver?

    also take statistical data of the current draw
%}

% for the dimensions graph, want a 2D plot of diagonal distance on x axis
% and num pedals on y axis, with a shaded region showing which ones are
% compatible.

enclosureDimSorted = sortrows(enclosures, 'diag');

figure(3); clf;
xlabel("Distance between diagonal screw holes (in)")


yyaxis left;
% scatter plot of the dimension vs number of products available for that
% dimension
scatterplot = scatter(enclosureDimSorted.diag, enclosureDimSorted.ProductCount);
ylabel("Number of Products Available at Given Dimension")
yyaxis right;
% line graph showing percent of the market covered by supporting this sized pedal
lineplot = plot(enclosureDimSorted.diag(~isnan(enclosureDimSorted.x)), cumsum(enclosureDimSorted.ProductCount(~isnan(enclosureDimSorted.x))) / sum(enclosureDimSorted.ProductCount(~isnan(enclosureDimSorted.x))));
ylabel("Ratio of Market Coverage by Supporting Up to This Size Enclosure")

% Add reference lines to show where requirements are
hline95 = refline(0, 0.95); hline95.LineStyle = ':'; hline95.Color = 'red';
hline80 = refline(0, 0.80); hline80.LineStyle = ':'; hline95.Color = 'green';

% add reference shading to show what is covered by current prototype
prototypeMaxDim = 5.15;
xlims = xlim;
ylims = ylim;
X = [xlims(1), prototypeMaxDim, prototypeMaxDim, xlims(1)];
Y = [ylims(1), ylims(1), ylims(2), ylims(2)];
prototypeCoverage = patch(X, Y, 'blue', 'EdgeColor', 'none')
alpha(prototypeCoverage, 0.1);

legend([scatterplot, lineplot, hline95, hline80, prototypeCoverage], ...
    ["(Popularity, Size) datapoint", {'Ratio of Pedals with $d_{max} \leq d$'}, {'$95\%$ Compatibility Goal'}, {'$80\%$ Compatibility Goal'}, "Range of Pedals Supported by Prototype"], ...
    'Location', 'East', 'interpreter', 'latex')


title("Pedal Compatibility")

%% Plot x & y to find two best fit lines, for the most compatibility

figure(4); clf;

enclosurePopSorted = sortrows(enclosures, 'ProductCount', 'descend')

% Plot the new slots
slot_width = 0.25
% Slot1 segment endpoints:
slot1 = [0.5, 1.5;
         1.5, 2.5;
         3, 2.5];
% Slot2 segment endpoints:
slot2 = [2.25, 1.75;
         3, 2.5];
     
hold on;
plot(slot1(:,1), slot1(:,2), 'r')
plot(-slot1(:,1), -slot1(:,2), 'r')

plot(slot2(:,1), slot2(:,2), 'b')
plot(-slot2(:,1), -slot2(:,2), 'b')
hold off;

N_plot = 40
for i=1:min(size(enclosurePopSorted,1), N_plot)
    if ~isnan(enclosurePopSorted.diag(i))
        plotRectangle(enclosurePopSorted.x(i), enclosurePopSorted.y(i), 0, 1);
    end
end

%% Would a 5 x 6 plate work?

productCountwDim = sum(enclosurePopSorted.ProductCount(~isnan(enclosurePopSorted.x)))

clearance = 0.25

% First try 5 x 6 vertical
Vertical5x6Enclosures = enclosurePopSorted((enclosurePopSorted.x < 5 - clearance) & (enclosurePopSorted.y < 6 - clearance), :);
percentVertical5x6 = sum(Vertical5x6Enclosures.ProductCount) / productCountwDim

% Try 5 x 6 horizontal
Horizontal5x6Enclosures = enclosurePopSorted((enclosurePopSorted.x < 6 - clearance) & (enclosurePopSorted.y < 5 - clearance), :);
percentHorizontal5x6 = sum(Horizontal5x6Enclosures.ProductCount) / productCountwDim

% Compare to 6 x 6 horizontal
Square6x6Enclosures = enclosurePopSorted((enclosurePopSorted.x < 6 - clearance) & (enclosurePopSorted.y < 6 - clearance), :);
percentSquare6x6 = sum(Square6x6Enclosures.ProductCount) / productCountwDim























