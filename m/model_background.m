function [ background_model ] = model_background( background_array_fd )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

[x,y,z,f] = size(background_array_fd);

% supa dupa mega model
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

se = strel('disk', 2);
background_model(:,:,:) = imdilate(background_model(:,:,:), se);
    
end

