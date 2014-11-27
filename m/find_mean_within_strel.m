%% =======================================================================%
% find_mean_within_strel.m                                                %
%=========================================================================%
% Function:     find_mean_within_strel                                    %
% Author(s):    Alexander Jenkins (JEN11214787)                           %
% Description:  Find average and std dev of each channel in an RGB image  %
%               underneath a structuring element. Other pixels are ignored%
% Returns:      Mean and std dev of R,G,B                                 %
%=========================================================================%

%% =======================================================================%
% find_mean_within_strel                                                  %
%                                                                         %
% Arguments:                                                              %
% IN(I)         The 2D RGB matrix to perform a median filter on           %
% IN(PL)        PixelList to act as a structuring element                 %
%=========================================================================%

function [R, G, B, SR, SG, SB] = find_mean_within_strel(I, PL)

% get number of pixels
N = size(PL);

% placeholders for extracted pixels
TempR = zeros(1, N(1));
TempG = zeros(1, N(1));
TempB = zeros(1, N(1));

% Get the pixels under the strel
for(i=1:N(1))
    loc1 = PL(i, 1);
    loc2 = PL(i, 2);
    TempR(i) = I(loc1, loc2, 1);
    TempG(i) = I(loc1, loc2, 2);
    TempB(i) = I(loc1, loc2, 3);
end

% Find avgs and std devs
R = mean(TempR);
G = mean(TempG);
B = mean(TempB);
SR = mean(TempR);
SG = mean(TempG);
SB = mean(TempB);

end