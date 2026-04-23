function output_image = histogram_equalization(img)
% HISTOGRAM_EQUALIZATION  Enhance contrast by equalizing the histogram.
%
%   output_image = histogram_equalization(img)
%
%   Parameters:
%       img  - Input image (grayscale or RGB). RGB is auto-converted to grayscale.
%
%   Returns:
%       output_image - Equalized grayscale image, uint8
%
%   Algorithm:
%       1. Compute the probability density function (PDF) of intensities.
%       2. Compute the cumulative distribution function (CDF).
%       3. Map each intensity:  s = round(CDF(r) * 255)
%
%   FIX: Original code crashed on RGB images. Added rgb2gray conversion.
%
%   Example:
%       img = imread('images/image.jpg');
%       out = histogram_equalization(img);

    % FIX: convert RGB to grayscale before processing
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    [r, c] = size(img);
    total  = r * c;

    % Step 1 - build PDF
    pdf = zeros(1, 256);
    for i = 1 : r
        for j = 1 : c
            pdf(img(i,j) + 1) = pdf(img(i,j) + 1) + 1;
        end
    end
    pdf = pdf / total;

    % Step 2 - build CDF
    cdf = zeros(1, 256);
    cdf(1) = pdf(1);
    for i = 2 : 256
        cdf(i) = cdf(i-1) + pdf(i);
    end

    % Step 3 - map intensities
    output_image = img;
    for i = 1 : r
        for j = 1 : c
            output_image(i,j) = round(cdf(img(i,j) + 1) * 255);
        end
    end
    output_image = uint8(output_image);

    figure;
    subplot(1,2,1); imshow(img);          title('Original Image');
    subplot(1,2,2); imshow(output_image); title('Histogram Equalization');
end
