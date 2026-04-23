function draw_histogram(img)
% DRAW_HISTOGRAM  Plot the intensity histogram of a grayscale image.
%
%   draw_histogram(img)
%
%   Parameters:
%       img  - Input image (grayscale or RGB). RGB is converted to grayscale.
%
%   Example:
%       img = imread('images/image.jpg');
%       draw_histogram(img);

    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    [r, c]    = size(img);
    frequency = zeros(1, 256);

    for i = 1 : r
        for j = 1 : c
            idx = double(img(i,j)) + 1;   % shift: intensity 0 -> index 1
            frequency(idx) = frequency(idx) + 1;
        end
    end

    n = 0 : 255;

    figure;
    subplot(1,2,1); imshow(img);           title('Grayscale Image');
    subplot(1,2,2); stem(n, frequency, 'Marker', 'none');
    xlabel('Intensity Level');
    ylabel('Pixel Count');
    title('Image Histogram');
    grid on;
end
