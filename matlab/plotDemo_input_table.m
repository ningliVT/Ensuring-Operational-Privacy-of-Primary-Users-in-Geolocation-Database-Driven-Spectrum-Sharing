% info for output files
userid = 'ning';
filename = 'Demo';

% same setting as java program does. Hard coded for now.
latStart = 45;
latEnd = 50;
LongStart = -100;
LongEnd = -95;
PU_Lat = 49;
PU_Lon = -99;
cellSize = 0.1;
rows = 5 / cellSize;
cols = 5 / cellSize;

importNumber = '0';
% import data from a text file
importName = ['/Users/ningli/Desktop/demoTable_', importNumber, '.txt'];
import = importdata(importName);
A = import.data;
M = zeros(rows, cols);
for i = 1: rows
    for j = 1 : cols
        M(i, j) = A(j + cols * (i - 1), 3);
    end
end

x = (LongStart):((LongEnd - LongStart)/(cols - 1)):(LongEnd);
y = (latStart):((latEnd - latStart)/(rows - 1)):(latEnd);
% [X,Y] = meshgrid(x,y);
[m,n] = size(M);

inverseM = zeros(m, n);
for i = 1: m
    inverseM(i, :) = M(m - i + 1, :);
end

minP = 0.5;
maxP = max(max(inverseM));
plotrange = minP:(maxP - minP)/4:maxP;

copy = inverseM;
for i = 1: m
    for j = 1 : n
        if copy(i, j) > plotrange(1, 1) && copy(i, j) < plotrange(1, 2)
            copy(i, j) = 0.5;
        else if copy(i, j) >= plotrange(1, 2) && copy(i, j) < plotrange(1, 3)
                copy(i, j) = 0.6;
            else if copy(i, j) >= plotrange(1, 3) && copy(i, j) < plotrange(1, 4)
                    copy(i, j) = 0.7;
                else if copy(i, j) >= plotrange(1, 4) && copy(i, j) < plotrange(1, 5)
                        copy(i, j) = 0.8;
                    else if copy(i, j) >= plotrange(1, 5)
                            copy(i, j) = 0.9;
                        else if copy(i, j) == 0
                                copy(i, j) = 0;
                            else
                                copy(i, j) = NaN;
                            end
                        end
                    end
                end
            end
        end
    end
end

% % change entries value to gain better output map
% I = zeros(length(A), 1);
% for i = 1:length(A)
%     if A(i,3) == 0
%         I(i) = NaN;
%     else if A(i, 3) == 0.5
%             I(i) = 0.5;
%     else
%         I(i) = 0.8;
%         end
%     end
% end
% Z = griddata(A(:,2),A(:,1),I,X,Y,'natural');

% plot on google map
figure();
contourf(x,y,copy);
title('Input interpolation by griddata');
xlabel('longitude');
ylabel('latitude');
% plot color bar
contourcmap('jet', 'Colorbar', 'on', ...
   'Location', 'vertical', ...
   'ColorAlignment', 'center',...
   'TitleString', 'Probability value');
hold on;
% draw the PU location on the map
plot(PU_Lon ,PU_Lat,'ko','MarkerSize',20);
% drwa google map
plot_google_map('maptype','hybrid','APIKey','AIzaSyDMSjokr-3WVHSYtZeW5xM2gI6uO8BkiMI');
hold off;

% Output the contours into pdf and png file
fileextension = '.pdf';
name = ['/Users/ningli/Desktop/', userid, '_', filename, '_probability_', importNumber, fileextension];
print('-dpdf',name);
fileextension = '.png';
name=['/Users/ningli/Desktop/', userid, '_', filename, '_probability_', importNumber, fileextension];
print('-dpng',name);

% close all;