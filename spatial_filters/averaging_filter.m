function output_image = averaging_filter(img, window_size)
% AVERAGING_FILTER  Apply a mean (box) filter to smooth an image.
%
%   output_image = averaging_filter(img)
%   output_image = averaging_filter(img, window_size)
%
%   Parameters:
%       img         - Input image (grayscale or RGB), uint8
%       window_size - (optional) Side length of the square kernel. Default: 5
%
%   Returns:
%       output_image - Filtered image (same size and type as input)
%
%   Example:
%       img = imread('images/image.jpg');
%       out = averaging_filter(img, 5);

    if nargin < 2
        window_size = 5;
    end

    kernel = ones(window_size) / window_size^2;
    output_image = imfilter(img, kernel, 'replicate');

    figure;
    subplot(1,2,1); imshow(img);        title('Original Image');
    subplot(1,2,2); imshow(output_image); title(sprintf('Averaging Filter (k=%d)', window_size));
end
