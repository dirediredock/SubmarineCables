
close all; clear; clc; format long g;

% Extract submarine cable data from URL and convert to a struct variable

fileGeoJSON = webread("https://raw.githubusercontent.com/telegeography/www.submarinecablemap.com/master/web/public/api/v3/cable/cable-geo.json");
cables = jsondecode(fileGeoJSON);

% The following forloop parses the struct variable "cables" and 1. counts the
% unqiue XY coordinate pair instances (stored in "countPoints"), 2. counts
% the number of unique cable polylines (stored in "countLines"), and 3.
% counts the unique cable identifiers (stored in "countNames"). These
% variables are then used for array pre-allocation.

countPoints = 0;
countLines = 0;
countNames = 0;

for i = 1:length(cables.features)
    
    polyLines = cables.features(i).geometry.coordinates;
    countNames = countNames + 1;
    
    if iscell(polyLines) == 0
        dims = size(polyLines);
        if dims(:,1) == 2
            lineA1 = squeeze(polyLines(1,:,:));
            lineA2 = squeeze(polyLines(2,:,:));
            LineA = cat(1,lineA1,lineA2);
            countPoints = countPoints + height(LineA);
            countLines = countLines + 2;
        else
            LineB = squeeze(polyLines);
            countPoints = countPoints + height(LineB);
            countLines = countLines + 1;
        end
    else
        for j = 1:length(polyLines)
            LineC = polyLines{j,1};
            countPoints = countPoints + height(LineC);
            countLines = countLines + 1;
        end
    end
end

% Following the architecture of the forloop above, two pre-allocated arrays
% will be populated with data in this next forloop below. First, "polyArray"
% holds all unique line points counted in "countPoints" across four
% dimensions: 1. longitude, 2. latitude, 3. cable bundle index,
% and 4. unique polyline. Second, "metaData" stores four string
% identifiers of the cable bundle: 1. id, 2. name, 3. color, and 4. feature
% ID. The cable bundle index (or "polyArray(:,3)") matches the index of
% "metaData".

polyArray = zeros(countPoints,4);
metaData = strings([countNames,4]);

nowIndex = 1;

for i = 1:length(cables.features)
    
    polyLines = cables.features(i).geometry.coordinates;
    
    metaData{i,1} = cables.features(i).properties.id;
    metaData{i,2} = cables.features(i).properties.name;
    metaData{i,3} = cables.features(i).properties.color;
    metaData{i,4} = cables.features(i).properties.feature_id;
    
    if iscell(polyLines) == 0
        
        dims = size(polyLines);
        
        if dims(:,1) == 2
            for j = 1:2
                LineA = squeeze(polyLines(j,:,:));
                polyArray(nowIndex:nowIndex+height(LineA)-1,1:2) = LineA;
                polyArray(nowIndex:nowIndex+height(LineA)-1,3) = i;
                polyArray(nowIndex:nowIndex+height(LineA)-1,4) = j;
                nowIndex = nowIndex + height(LineA);
            end
        else
            j = 1;
            LineB = squeeze(polyLines);
            polyArray(nowIndex:nowIndex+height(LineB)-1,1:2) = LineB;
            polyArray(nowIndex:nowIndex+height(LineB)-1,3) = i;
            polyArray(nowIndex:nowIndex+height(LineB)-1,4) = j;
            nowIndex = nowIndex + height(LineB);
        end
    else
        for j = 1:length(polyLines)
            LineC = polyLines{j,1};
            polyArray(nowIndex:nowIndex+height(LineC)-1,1:2) = LineC;
            polyArray(nowIndex:nowIndex+height(LineC)-1,3) = i;
            polyArray(nowIndex:nowIndex+height(LineC)-1,4) = j;
            nowIndex = nowIndex + height(LineC);
        end
    end
end

% Save data

save('polyArray.mat','polyArray','-v7.3');
save('metaData.mat','metaData','-v7.3');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extra visualization

%{
    figure('Position',[120,60,1420,780],'Color','k'); axis off; hold on; 

    for i = 1:length(cables.features)

        polyLines = cables.features(i).geometry.coordinates;
        countNames = countNames + 1;

        if iscell(polyLines) == 0
            dims = size(polyLines);
            if dims(:,1) == 2
                lineA1 = squeeze(polyLines(1,:,:));
                lineA2 = squeeze(polyLines(2,:,:));
                plot(lineA1(:,1),lineA1(:,2),'w','LineWidth',0.1);
                plot(lineA2(:,1),lineA2(:,2),'w','LineWidth',0.1);

            else
                LineB = squeeze(polyLines);
                plot(LineB(:,1),LineB(:,2),'w','LineWidth',0.1);
            end
        else
            for j = 1:length(polyLines)
                LineC = polyLines{j,1};
                plot(LineC(:,1),LineC(:,2),'w','LineWidth',0.1);
            end
        end
    end
%}

