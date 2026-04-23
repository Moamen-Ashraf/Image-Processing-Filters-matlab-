function output_image = gaussian_filter(image, filter_size, sigma)
% GAUSSIAN_FILTER  Blur an image using a 2-D Gaussian kernel (manual convolution).
%
%   output_image = gaussian_filter(image, filter_size, sigma)
%
%   Parameters:
%       image       - Input RGB image, uint8
%       filter_size - Size of the square Gaussian kernel (e.g. 5)
%       sigma       - Standard deviation of the Gaussian (e.g. 1.5)
%
%   Returns:
%       output_image - Blurred grayscale image, uint8
%
%   FIX: Original code computed  filter1 * filter1'  (outer product), which
%        produces a rank-1 matrix, not a proper 2-D Gaussian.
%        Corrected to use fspecial('gaussian') directly.
%
%   Example:
%       img = imread('images/image.jpg');
%       out = gaussian_filter(img, 5, 1.5);

    % Build a proper 2-D Gaussian kernel
    kernel = fspecial('gaussian', filter_size, sigma);   % FIX: was filter1*filter1'

    gray_image    = rgb2gray(image);
    padded_image  = padarray(gray_image, [filter_size-1  filter_size-1], 'replicate', 'both');

    [r, c]       = size(padded_image);
    output_image = zeros(r, c);

    for i = 1 : r - filter_size + 1
        for j = 1 : c - filter_size + 1
            sub_arr = double(padded_image(i : i+filter_size-1,  j : j+filter_size-1));
            val     = sum(sub_arr(:) .* kernel(:));
            output_image(i + filter_size - 1,  j + filter_size - 1) = val;
        end
    end

    % Normalise to [0, 255]
    output_image = output_image - min(output_image(:));
    if max(output_image(:)) > 0
        output_image = output_image / max(output_image(:));
    end
    output_image = uint8(output_image * 255);

    figure;
    subplot(1,2,1); imshow(image);        title('Original Image');
    subplot(1,2,2); imshow(output_image); title(sprintf('Gaussian Filter (\\sigma=%.1f)', sigma));
end
