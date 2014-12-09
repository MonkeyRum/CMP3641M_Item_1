%% =======================================================================%
% remove_background.m                                                     %
%=========================================================================%
% Function:     remove_background                                         %
% Author(s):    Alexander Jenkins (JEN11214787)                           %
% Description:  Uses a background model from model_background.m to remove %
%               the background of an image that contains the background   %
% Returns:      Logical mask of background (zero) and foreground (one)    %
%=========================================================================%

%% =======================================================================%
% remove_background                                                       %
%                                                                         %
% Arguments:                                                              %
% IN(model)   Background model                                            %
% IN(image)   Image to create background mask from                        %
%=========================================================================%

function [ logical_segment ] = remove_background( model, image )

WHD = size(image);
w = WHD(1);
h = WHD(2);

logical_segment = ones(w, h, 'uint8');

for y=1:h
    for x=1:w
       
        r = image(x, y, 1) + 1;
        g = image(x, y, 2) + 1;
        b = image(x, y, 3) + 1;
        
        % remove background if the colour is set in the model
        if model(r, g, b)
            logical_segment(x, y) = 0;
        end

        str = ['reference pixel: [', num2str(x), ',', num2str(y), ']\n'];
        fprintf(str);
        
    end
end

% make binary
logical_segment = logical_segment > 0;

end

