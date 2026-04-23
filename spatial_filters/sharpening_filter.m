function output_image = sharpening_filter(img)
% SHARPENING_FILTER  Sharpen an image using a Laplacian-based kernel.
%
%   output_image = sharpening_filter(img)
%
%   Parameters:
%       img  - Input image (grayscale or RGB), uint8
%
%   Returns:
%       output_image - Sharpened image, uint8
%
%   The kernel used is the standard 4-connected Laplacian sharpener:
%       [0 -1 0; -1 5 -1; 0 -1 0]
%
%   Example:
%       img = imread('images/image.jpg');
%       out = sharpening_filter(img);

    kernel       = [0 -1 0; -1 5 -1; 0 -1 0];
    output_image = imfilter(img, kernel, 'replicate');

    figure;
    subplot(1,2,1); imshow(img);         title('Original Image');
    subplot(1,2,2); imshow(output_image); title('Sharpening Filter');
end
