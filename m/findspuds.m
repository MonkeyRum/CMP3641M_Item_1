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
if(DEBUG)
    figure; imshow(I); title('Original input');
end

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

% step 4 
% open some gaps
se = strel('diamond',4);
open_image = imopen(fill_image, se);
if(DEBUG)
    figure; imshow(open_image); title('Open');
end

% step 5
% label potatoes
[L, num] = bwlabel(open_image, 8);
outline_image = label2rgb(L, 'lines', 'k', 'shuffle');
outline_image = imdilate(outline_image,se) - outline_image;
if(DEBUG)
    figure; imshow(outline_image); title('Outlines');
end