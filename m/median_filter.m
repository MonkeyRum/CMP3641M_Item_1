%% =======================================================================%
% median_filter.m                                                         %
%=========================================================================%
% Function:     median_filter                                             %
% Author(s):    Alexander Jenkins (JEN11214787)                           %
% Description:  Performs a median filter on a Matrix with two dimensions  %
% Returns:      Median filtered matrix                                    %
%=========================================================================%

%% =======================================================================%
% median_filter                                                           %
%                                                                         %
% Arguments:                                                              %
% IN(I)         The 2D matrix to perform a median filter on               %
% IN(A)         Vector containing [Height, Width]                         %
%=========================================================================%

function MedianFilteredImage = median_filter(I, V)

% This function exists in a perfect world :)
% I assume the image is big enough and yada yada...

% Initialise the return matrix with the same size as I and zero it out
M = size(I, 1); % Height
N = size(I, 2); % Width
MedianFilteredImage = uint8(zeros(M, N));

A = V(1); % Window height
B = V(2); % Window width

% Used to adjust for even sized windows
% Since the capture loop will always take the central pixel regardless
AdjustA = not(mod(A, 2)); 
AdjustB = not(mod(B, 2));

% Pre-compute some stuff
A2 = floor(A/2);
B2 = floor(B/2);

% Replicate the border pixels so they don't mess with the median
I2 = padarray(I, [A, B], 'replicate');

% Loop the 'original' pixels
for m = 1+A:M+A
    for n = 1+B:N+B
        
        Capture = I2(m - A2:m + A2 - AdjustA, n - B2: n + B2 - AdjustB);
        Capture = Capture(:); % flatten our matrix
        Med = median(Capture); % horrifically slow
        
        MedianFilteredImage(m-A, n-B) = Med;
        
    end    
end