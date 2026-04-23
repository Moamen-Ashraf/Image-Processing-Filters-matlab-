function output_image = sobel_edge_detection(image)
% SOBEL_EDGE_DETECTION  Detect edges using the Sobel operator (manual convolution).
%
%   output_image = sobel_edge_detection(image)
%
%   Parameters:
%       image - Input image (RGB or grayscale), uint8
%
%   Returns:
%       output_image - Gradient magnitude image, normalised to [0,1] double
%
%   The Sobel operator computes horizontal and vertical gradients:
%       Gx = [-1 0 1; -2 0 2; -1 0 1]
%       Gy = Gx'
%   Magnitude = sqrt(Gx^2 + Gy^2)
%
%   FIX: Original 'Edge_Detection.m' accepted a filter_size parameter but
%        hardcoded a 3x3 kernel internally, making the parameter misleading.
%        Simplified to always use the standard 3x3 Sobel kernel.
%
%   Example:
%       img = imread('images/image.jpg');
%       out = sobel_edge_detection(img);

    FILTER_SIZE = 3;

    gray_image   = rgb2gray(image);
    padded_image = padarray(gray_image, [1 1], 'replicate', 'both');

    Gx = [-1 0 1; -2 0 2; -1 0 1];   % horizontal gradient kernel
    Gy = Gx';                          % vertical gradient kernel

    [rows, cols] = size(padded_image);
    grad_x = zeros(rows, cols);
    grad_y = zeros(rows, cols);

    for i = 1 : rows - FILTER_SIZE + 1
        for j = 1 : cols - FILTER_SIZE + 1
            patch        = double(padded_image(i:i+2, j:j+2));
            cx           = i + floor(FILTER_SIZE/2);
            cy           = j + floor(FILTER_SIZE/2);
            grad_x(cx,cy) = sum(sum(patch .* Gx));
            grad_y(cx,cy) = sum(sum(patch .* Gy));
        end
    end

    magnitude    = sqrt(grad_x.^2 + grad_y.^2);
    magnitude    = magnitude(2:end-1, 2:end-1);   % remove padding

    % Normalise to [0, 1] for display
    magnitude    = magnitude - min(magnitude(:));
    output_image = magnitude / max(magnitude(:));

    figure;
    subplot(1,2,1); imshow(gray_image);   title('Grayscale Image');
    subplot(1,2,2); imshow(output_image); title('Sobel Edge Detection');
end
