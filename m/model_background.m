%% =======================================================================%
% model_background.m                                                      %
%=========================================================================%
% Function:     model_background                                          %
% Author(s):    Alexander Jenkins (JEN11214787)                           %
% Description:  Creates a 3D model of the background by mapping colour    %
%               into 3D space. A dilation is applied to 'absorb' near     %
%               colours                                                   %
% Returns:      Background model                                          %
%=========================================================================%

%% =======================================================================%
% model_background                                                        %
%                                                                         %
% Arguments:                                                              %
% IN(background_array_fd)   4D background video frames (x,y,colour,frames %
% IN(d)                     Size of dilation strel (2-4 recommended       %
%=========================================================================%

function [ background_model ] = model_background( background_array_fd, d )

% MatLab likes to hold onto the past. This can get really slow but should
% run okay on a fresh MatLab process with enough system resources.
% If slow down occurs significantly reduce the number of frames in the
% reference background.

[x,y,z,f] = size(background_array_fd);

% supa dupa mega model
% use a colour's rgb values as indicies into the cube
% set value to 1 if the colour is found in the background frames
% only really works if foreground have distinctly different rgb...
% which is not always the case
background_model = zeros(255,255,255,'uint8');

for i=1:f
    
    for m=1:y
        for n=1:x
            
            % +1 to move 0-254 into 1-255 for MatLab's 1 based indexing
            r = background_array_fd(n, m, 1, i) + 1;
            g = background_array_fd(n, m, 2, i) + 1;
            b = background_array_fd(n, m, 3, i) + 1;
            background_model(r, g, b) = 1;
            
        end
    end
    
    str = ['modelling frame: ', num2str(i), '/', num2str(f), '\n'];
    fprintf(str);
    
end

str = ['post-proeccsing model...', '\n'];
fprintf(str);

% dilate our 3D colour cube to assimilate colours close to the ones we
% flagged in the previous step
se = strel('disk', d);
background_model(:,:,:) = imdilate(background_model(:,:,:), se);
    
end

