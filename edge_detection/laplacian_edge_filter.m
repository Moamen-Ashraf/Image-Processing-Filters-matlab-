function output_image = laplacian_edge_filter(img)
% LAPLACIAN_EDGE_FILTER  Detect edges using a 3x3 Laplacian kernel.
%
%   output_image = laplacian_edge_filter(img)
%
%   Parameters:
%       img  - Input image (grayscale or RGB), uint8
%
%   Returns:
%       output_image - Edge-enhanced image, uint8
%
%   The 8-connected Laplacian kernel used:
%       [-1 -1 -1]
%       [-1  8 -1]
%       [-1 -1 -1]
%   This highlights regions of rapid intensity change (edges) in all directions.
%
%   Example:
%       img = imread('images/image.jpg');
%       out = laplacian_edge_filter(img);

    kernel       = [-1 -1 -1; -1 8 -1; -1 -1 -1];
    output_image = imfilter(img, kernel, 'replicate');

    figure;
    subplot(1,2,1); imshow(img);          title('Original Image');
    subplot(1,2,2); imshow(output_image); title('Laplacian Edge Detection');
end
