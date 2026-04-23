function output_image = median_filter(img)
% MEDIAN_FILTER  Remove salt-and-pepper noise using a 3x3 median filter.
%
%   output_image = median_filter(img)
%
%   Parameters:
%       img  - Input image (grayscale or RGB), uint8
%
%   Returns:
%       output_image - Filtered image, uint8
%
%   The median filter replaces each pixel with the median value of its
%   3x3 neighbourhood. It is highly effective against impulse (salt &
%   pepper) noise while preserving edges better than averaging filters.
%
%   Example:
%       img = imread('images/image.jpg');
%       out = median_filter(img);

    padded = padarray(img, [1 1], 'replicate', 'both');

    [new_rows, new_cols, channels] = size(padded);
    output_image = zeros(size(img));

    for ch = 1 : channels
        for row = 2 : new_rows - 1
            for col = 2 : new_cols - 1
                neighbourhood = padded(row-1:row+1, col-1:col+1, ch);
                sorted        = sort(neighbourhood(:));
                output_image(row-1, col-1, ch) = sorted(5);   % median of 9 values
            end
        end
    end

    output_image = uint8(output_image);

    figure;
    subplot(1,2,1); imshow(img);         title('Original Image');
    subplot(1,2,2); imshow(output_image); title('Median Filter');
end
