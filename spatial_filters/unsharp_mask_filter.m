function output_image = unsharp_mask_filter(img, sigma)
% UNSHARP_MASK_FILTER  Sharpen an image via unsharp masking.
%
%   output_image = unsharp_mask_filter(img)
%   output_image = unsharp_mask_filter(img, sigma)
%
%   Parameters:
%       img   - Input image (grayscale or RGB), uint8
%       sigma - (optional) Standard deviation for the Gaussian blur. Default: 2
%
%   Returns:
%       output_image - Sharpened image, uint8
%
%   Algorithm:
%       mask         = original - blurred
%       output_image = original + mask
%   which simplifies to:  output_image = 2*original - blurred
%
%   Example:
%       img = imread('images/image.jpg');
%       out = unsharp_mask_filter(img, 2);

    if nargin < 2
        sigma = 2;
    end

    blurred      = imgaussfilt(img, sigma);
    mask         = imsubtract(img, blurred);
    output_image = imadd(img, mask);

    figure;
    subplot(1,2,1); imshow(img);         title('Original Image');
    subplot(1,2,2); imshow(output_image); title(sprintf('Unsharp Mask (\\sigma=%.1f)', sigma));
end
