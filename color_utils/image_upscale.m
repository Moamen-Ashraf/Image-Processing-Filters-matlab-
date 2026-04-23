function output_image = image_upscale(img, factor, method)
% IMAGE_UPSCALE  Upscale an image by an integer factor using nearest-neighbour
%                or bilinear interpolation.
%
%   output_image = image_upscale(img, factor)
%   output_image = image_upscale(img, factor, method)
%
%   Parameters:
%       img    - Input image (grayscale or RGB), uint8
%       factor - Integer scale factor (e.g. 2 doubles the resolution)
%       method - (optional) 'nearest' or 'bilinear'. Default: 'nearest'
%
%   Returns:
%       output_image - Upscaled image, uint8
%
%   FIX (DM_1L): Original 'bilinear' branch referenced undefined variables
%                Round, Max, Min, Fact — code crashed immediately.
%                Replaced with correct nearest-neighbour pixel replication.
%
%   Example:
%       img = imread('images/image.jpg');
%       out = image_upscale(img, 2, 'nearest');

    if nargin < 3
        method = 'nearest';
    end

    [r, c, ch]    = size(img);
    new_r         = r * factor;
    new_c         = c * factor;
    output_image  = zeros(new_r, new_c, ch, 'uint8');

    switch lower(method)

        case 'nearest'
            % Nearest-neighbour: replicate each pixel into a factor×factor block
            for k = 1 : ch
                for i = 1 : r
                    for j = 1 : c
                        row_range = (i-1)*factor+1 : i*factor;
                        col_range = (j-1)*factor+1 : j*factor;
                        output_image(row_range, col_range, k) = img(i, j, k);
                    end
                end
            end

        case 'bilinear'
            % Bilinear interpolation using MATLAB built-in
            output_image = imresize(img, factor, 'bilinear');

        otherwise
            error('image_upscale: unknown method "%s". Use ''nearest'' or ''bilinear''.', method);
    end

    figure;
    subplot(1,2,1); imshow(img);          title('Original Image');
    subplot(1,2,2); imshow(output_image); title(sprintf('Upscaled x%d (%s)', factor, method));
end
