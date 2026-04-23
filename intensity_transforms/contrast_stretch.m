function output_image = contrast_stretch(img)
% CONTRAST_STRETCH  Stretch pixel intensities to fill the full [0, 255] range.
%
%   output_image = contrast_stretch(img)
%
%   Parameters:
%       img  - Input image (grayscale or RGB), uint8
%
%   Returns:
%       output_image - Contrast-stretched image, uint8
%
%   Formula (per channel):
%       new_val = (new_max - new_min) / (old_max - old_min) * (val - old_min) + new_min
%   where new_min=0, new_max=255 and old_min/old_max are the image extremes.
%
%   Example:
%       img = imread('images/image.jpg');
%       out = contrast_stretch(img);

    [r, c, ch]   = size(img);
    output_image = zeros(r, c, ch);

    old_min = double(min(img(:)));
    old_max = double(max(img(:)));
    new_min = 0;
    new_max = 255;

    scale = (new_max - new_min) / (old_max - old_min);

    for k = 1 : ch
        for i = 1 : r
            for j = 1 : c
                val = scale * (double(img(i,j,k)) - old_min) + new_min;
                val = min(max(val, 0), 255);
                output_image(i,j,k) = val;
            end
        end
    end

    output_image = uint8(output_image);

    figure;
    subplot(1,2,1); imshow(img);         title('Original Image');
    subplot(1,2,2); imshow(output_image); title('Contrast Stretch');
end
