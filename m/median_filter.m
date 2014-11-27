%% =======================================================================%
% median_filter.m                                                         %
%=========================================================================%
% Function:     median_filter                                             %
% Author(s):    Alexander Jenkins (JEN11214787)                           %
% Description:  Performs a median filter on a Matrix with two dimensions  %
% Returns:      Median filtered matrix                                    %
%                                                                         %
% Limits:                                                                 %
%               - Even sized capture dimension gets expanded to next odd  %
%=========================================================================%

%% =======================================================================%
% findspuds                                                               %
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

% Replicate the border pixels so they don't mess with the median
I2 = padarray(I, [A, B], 'replicate');

% Pre-compute some stuff
A2 = floor(A/2);
B2 = floor(B/2);

% Loop the 'original' pixels
for m = 1+A:M+A
    for n = 1+B:N+B
        
        % Get our capture... will add stuff on even capture dimensions
        Capture = I2(m - A2:m + A2, n - B2: n + B2);
        Capture = Capture(:); % flatten our matrix
        Med = median(Capture);
        
        MedianFilteredImage(m-A, n-B) = Med;
        
    end    
end