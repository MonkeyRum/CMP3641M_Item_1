function [ segmented ] = task2( input_args )

% I assume the folder Spud dataset 2\Spud dataset 2 is available in path

% gain background frames
obj = mmreader('beltpotatoes_small.avi');
video = obj.read();
bg = video(:,:,:,1:454); % bg frames

% model the frames
model = model_background(bg, 3);

% create foreground mask
I = imread(input_args);
mask = remove_background(model, I);

% clean up the mask
area = bwareaopen(mask, 500);
fill = imfill(area, 'holes');

filter = fspecial('gaussian',[5 5],2);
filtered = imfilter(fill, filter, 'same');

% apply the mask and display the result
segmented = I;
segmented(~repmat(filtered, [1,1,3])) = 0;

% do some labelling
[L, num] = bwlabel(filtered, 8);
props = regionprops(L, 'All');

I2 = segmented; % don't mess with the original image
se = strel('diamond',1);
outline_image = label2rgb(L, 'lines', 'k', 'shuffle');
outline_image = imdilate(outline_image,se) - outline_image;
thresh = rgb2gray(outline_image) > 0;
blue = I2(:,:,3);
blue(thresh) = 255;
I2(:,:,3) = blue;
figure; imshow(I2);

c = [1,1,1];
for m = 1:num
    
    % set up some vars
    x = props(m).Centroid(1);
    y = props(m).Centroid(2);
    b1 = floor(props(m).BoundingBox(1));
    b2 = floor(props(m).BoundingBox(2));
    b3 = floor(props(m).BoundingBox(3));
    b4 = floor(props(m).BoundingBox(4));
    
    % plot
    text(x, y, num2str(m), 'Color', c, 'FontWeight', 'bold');
    rectangle('Position', [b1,b2,b3,b4], 'EdgeColor', c);
    
end

end

