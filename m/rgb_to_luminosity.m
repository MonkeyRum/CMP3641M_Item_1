%% =======================================================================%
% rgb_to_luminosity.m                                                     %
%=========================================================================%
% Function:     rgb2luminosity                                            %
% Author(s):    Alexander Jenkins (JEN11214787)                           %
% Description:  Converts rgb (3 channel) image to luminosity (1 channel)  %
% Returns:      Luminosity image                                          %
%=========================================================================%

%% =======================================================================%
% rgb_to_luminosity                                                       %
%                                                                         %
% Arguments:                                                              %
% IN(I)         The 2D matrix to convert to luminosity                    %
%=========================================================================%

function GreyImage = rgb_to_luminosity(I)

% Initialise the return matrix with the same size as I and zero it out
M = size(I, 1); %Height
N = size(I, 2); %Width
GreyImage = zeros(M, N);

for m = 1:M
    for n = 1:N
        % Humans perceive green more, read more at the GIMP project
        GreyImage(m,n) = I(m,n,1)*0.21 + I(m,n,2)*0.72 + I(m,n,2)*0.07;
    end
end

GreyImage = uint8(GreyImage);

end