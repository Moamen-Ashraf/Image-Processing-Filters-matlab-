function output_image = weighted_average_filter(img)
% WEIGHTED_AVERAGE_FILTER  Apply a 3x3 weighted (Gaussian-like) smoothing filter.
%
%   output_image = weighted_average_filter(img)
%
%   Parameters:
%       img  - Input image (grayscale or RGB), uint8
%
%   Returns:
%       output_image - Filtered image
%
%   The kernel used is:  [1 2 1; 2 4 2; 1 2 1] / 16
%   This is the standard 3x3 binomial approximation to a Gaussian.
%
%   Example:
%       img = imread('images/image.jpg');
%       out = weighted_average_filter(img);

    kernel = [1 2 1; 2 4 2; 1 2 1];
    kernel = kernel / sum(kernel(:));   % normalise so weights sum to 1

    output_image = imfilter(img, kernel, 'symmetric');

    figure;
    subplot(1,2,1); imshow(img);         title('Original Image');
    subplot(1,2,2); imshow(output_image); title('Weighted Average Filter');
end
