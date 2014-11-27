%% =======================================================================%
% findspuds.m                                                             %
%=========================================================================%
% Function:     findspuds                                                 %
% Author(s):    Alexander Jenkins (JEN11214787)                           %
% Description:  Detects potatoes on a black background and performs the   %
%               following actions:                                        %
%                   - Number of potatoes detected                         %
%                   - Per potato:                                         %
%                       - (x,y) location of the centroid of the potato    %
%                       - the eccentricity of the potato                  %
%                       - the mean and standard deviation of the R, G and %
%                          B colour values in the potato                  %
%                       - the smoothness value of the potato              %
%                       - the average entropy of the potato               %
%=========================================================================%

%% =======================================================================%
% findspuds                                                               %
%                                                                         %
% Arguments:                                                              %
% IN(i)         The image that contains potatoes on a black background    %
%=========================================================================%

function findspuds(I)

DEBUG = 0;

%% STEP 0
figure; imshow(I); title('Original input'); hold on;

%% STEP 1
% Create a grey scale version of the image in order to better remove the
% background noise, since the noise from all channels will coalesce
GI = rgb_to_luminosity(I);
if(DEBUG)
    figure; imshow(GI); title('Luminosity');
end

% Use a median filter to remove noise artefacts
MI = median_filter(GI, [3, 3]); % median filtered image
if(DEBUG)
    figure; imshow(MI); title('Median filtered');
end

FI = GI - MI; % filtered image
GI = GI - FI;
if(DEBUG)
    figure; imshow(GI); title('Filtered');
end

%% STEP 2
% Create a black / white 'mask' that can be used to segment out the
% potatoes from the background
BW = GI > 20;
if(DEBUG)
    figure; imshow(BW); title('Logical');
end

% step 3 
% clean up - fill potato
%fill_image = imfill(BW, 'holes');
% really slow because of Java import
fill_image = fill_holes(BW);
if(DEBUG)
    figure; imshow(fill_image); title('Fill holes');
end

%% step 4 
% open some gaps
se = strel('diamond',4);
open_image = imopen(fill_image, se);
if(DEBUG)
    figure; imshow(open_image); title('Open');
end

%% step 5
% label potatoes
[L, num] = bwlabel(open_image, 8);
props = regionprops(L, 'All');

% output
str = ['Number of potatoes:\t', num2str(num), '\n\n'];
fprintf(str);

for(m = 1:num)
    % info
    c = [1,1,1];
    
    area = props(m).Area;
    % 0 is not circular, 1 is circular
    circularity = (4*pi*area)/(props(m).Perimeter^2);
    eccentricity = props(m).Eccentricity;
    
    x = props(m).Centroid(1);
    y = props(m).Centroid(2);
    
    b1 = props(m).BoundingBox(1);
    b2 = props(m).BoundingBox(2);
    b3 = props(m).BoundingBox(3);
    b4 = props(m).BoundingBox(4);
    
    % plot
    text(x, y, num2str(m), 'Color', c, 'FontWeight', 'bold');
    rectangle('Position', [b1,b2,b3,b4], 'EdgeColor', c);
    
    % print
    str = ['Potato #', num2str(m), '\n', 'Centroid:\t\t[', num2str(x), ', ', num2str(y), ']\n', 'Eccentricity:\t', num2str(eccentricity), '\n', 'Circularity:\t', num2str(circularity), '\n'];
    fprintf(str);
    str = ['Averages(R,G,B)\t[', num2str(m), ', ', num2str(m), ', ', num2str(m), ']\n'];
    fprintf(str);
    str = ['Stddev(R,G,B)\t[', num2str(m), ', ', num2str(m), ', ', num2str(m), ']\n'];
    fprintf(str);
    str = ['Avg Entropy\t\t', num2str(m), '\n\n'];
    fprintf(str);
end

outline_image = label2rgb(L, 'lines', 'k', 'shuffle');
outline_image = imdilate(outline_image,se) - outline_image;
%imshow(outline_image); title('Outlines');




















