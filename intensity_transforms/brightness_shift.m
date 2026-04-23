function output_image = brightness_shift(img, offset)
% BRIGHTNESS_SHIFT  Brighten or darken an image by a constant offset.
%
%   output_image = brightness_shift(img, offset)
%
%   Parameters:
%       img    - Input image (grayscale or RGB), uint8
%       offset - Integer added to every pixel.
%                Positive values brighten; negative values darken.
%                Output is clamped to [0, 255].
%
%   Returns:
%       output_image - Adjusted image, uint8
%
%   Example:
%       img = imread('images/image.jpg');
%       bright = brightness_shift(img,  60);   % brighten
%       dark   = brightness_shift(img, -60);   % darken

    [r, c, ch]   = size(img);
    output_image = zeros(r, c, ch);

    for k = 1 : ch
        for i = 1 : r
            for j = 1 : c
                val = double(img(i,j,k)) + offset;
                val = min(max(val, 0), 255);   % clamp to [0,255]
                output_image(i,j,k) = val;
            end
        end
    end

    output_image = uint8(output_image);

    label = 'Brightened';
    if offset < 0, label = 'Darkened'; end

    figure;
    subplot(1,2,1); imshow(img);         title('Original Image');
    subplot(1,2,2); imshow(output_image); title(sprintf('%s (offset=%+d)', label, offset));
end
