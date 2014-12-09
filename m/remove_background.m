function [ logical_segment ] = remove_background( model, image )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

WHD = size(image);
w = WHD(1);
h = WHD(2);

logical_segment = ones(w, h, 'uint8');

for y=1:h
    for x=1:w
       
        r = image(x, y, 1) + 1;
        g = image(x, y, 2) + 1;
        b = image(x, y, 3) + 1;
        
        if model(r, g, b)
            logical_segment(x, y) = 0;
        end
                
        str = ['reference frame: [', num2str(x), ',', num2str(y), ']\n'];
        fprintf(str);
        
    end
end

% make binary
logical_segment = logical_segment > 0;

end

