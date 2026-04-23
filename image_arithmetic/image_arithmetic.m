function [add_image, sub_image] = image_arithmetic(img1, img2)
% IMAGE_ARITHMETIC  Add and subtract two images pixel-by-pixel.
%
%   [add_image, sub_image] = image_arithmetic(img1, img2)
%
%   Parameters:
%       img1  - First input image (grayscale or RGB), uint8
%       img2  - Second input image (grayscale or RGB), uint8
%               img1 is resized to match img2 if dimensions differ.
%
%   Returns:
%       add_image - Pixel-wise sum,        clamped to [0,255], uint8
%       sub_image - Pixel-wise difference, clamped to [0,255], uint8
%
%   Example:
%       img1 = imread('images/image.jpg');
%       img2 = imread('images/image1.jpg');
%       [added, subtracted] = image_arithmetic(img1, img2);

    [r, c, ch] = size(img2);
    img1       = imresize(img1, [r, c]);

    add_image = zeros(r, c, ch);
    sub_image = zeros(r, c, ch);

    for k = 1 : ch
        for i = 1 : r
            for j = 1 : c
                add_image(i,j,k) = double(img1(i,j,k)) + double(img2(i,j,k));
                sub_image(i,j,k) = double(img1(i,j,k)) - double(img2(i,j,k));
            end
        end
    end

    add_image = uint8(min(add_image, 255));
    sub_image = uint8(max(sub_image, 0));

    figure;
    subplot(2,2,1); imshow(img1);      title('Image 1');
    subplot(2,2,2); imshow(img2);      title('Image 2');
    subplot(2,2,3); imshow(add_image); title('Addition  (img1 + img2)');
    subplot(2,2,4); imshow(sub_image); title('Subtraction (img1 - img2)');
end
