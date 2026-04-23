function output_image = image_negative(img)
% IMAGE_NEGATIVE  Compute the photographic negative of an image.
%
%   output_image = image_negative(img)
%
%   Parameters:
%       img  - Input image (grayscale or RGB), uint8
%
%   Returns:
%       output_image - Negative image, uint8
%
%   Formula:  s = 255 - r   (per pixel, per channel)
%
%   Example:
%       img = imread('images/image.jpg');
%       out = image_negative(img);

    [r, c, ch]   = size(img);
    output_image = zeros(r, c, ch);

    for k = 1 : ch
        for i = 1 : r
            for j = 1 : c
                output_image(i,j,k) = 255 - double(img(i,j,k));
            end
        end
    end

    output_image = uint8(output_image);

    figure;
    subplot(1,2,1); imshow(img);         title('Original Image');
    subplot(1,2,2); imshow(output_image); title('Image Negative');
end
