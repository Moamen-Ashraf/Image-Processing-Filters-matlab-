function output_image = quantization(img, bits)
% QUANTIZATION  Reduce the number of intensity levels (bit-depth reduction).
%
%   output_image = quantization(img)
%   output_image = quantization(img, bits)
%
%   Parameters:
%       img  - Input image (grayscale or RGB), uint8
%       bits - (optional) Number of bits per channel. Default: 1
%              Resulting grey levels = 2^bits
%
%   Returns:
%       output_image - Quantized image, uint8
%
%   Example:
%       img = imread('images/image.jpg');
%       out2 = quantization(img, 2);   % 4 grey levels
%       out4 = quantization(img, 4);   % 16 grey levels

    if nargin < 2
        bits = 1;
    end

    [r, c, ch]   = size(img);
    output_image = zeros(r, c, ch);

    grey_levels = 2 ^ bits;
    gap         = 256 / grey_levels;
    colors      = gap : gap : 256;   % representative values for each bin

    for k = 1 : ch
        for i = 1 : r
            for j = 1 : c
                idx = floor(double(img(i,j,k)) / gap);
                idx = max(idx, 1);                      % clamp index to valid range
                idx = min(idx, grey_levels);
                output_image(i,j,k) = colors(idx);
            end
        end
    end

    output_image = uint8(output_image);

    figure;
    subplot(1,2,1); imshow(img);         title('Original Image');
    subplot(1,2,2); imshow(output_image); title(sprintf('Quantization (%d bits, %d levels)', bits, grey_levels));
end
