function output_image = power_law_transform(img, gamma)
% POWER_LAW_TRANSFORM  Apply gamma (power-law) intensity transformation.
%
%   output_image = power_law_transform(img, gamma)
%
%   Parameters:
%       img   - Input image (grayscale or RGB), uint8
%       gamma - Exponent.
%               gamma < 1  brightens dark regions (useful for dark images).
%               gamma > 1  darkens bright regions (useful for washed-out images).
%               gamma = 1  is the identity transform.
%
%   Returns:
%       output_image - Transformed image, uint8
%
%   Formula:  s = c * r^gamma   where c = 255 / (255^gamma)
%
%   FIX: Original code computed the scaling constant T inside the pixel
%        loop on every iteration but used it after the loop.  Moved T
%        calculation before the loops so it is always available.
%
%   Example:
%       img = imread('images/image.jpg');
%       out = power_law_transform(img, 0.5);   % brighten

    [r, c, ch]   = size(img);
    output_image = zeros(r, c, ch);

    % FIX: T must be computed BEFORE the loop (was inside loop — same result
    %      but wastes cycles and was confusingly scoped in the original)
    T = 255 / (255 ^ gamma);

    for k = 1 : ch
        for i = 1 : r
            for j = 1 : c
                old_val = double(img(i,j,k));
                output_image(i,j,k) = old_val ^ gamma;
            end
        end
    end

    output_image = uint8(output_image * T);

    figure;
    subplot(1,2,1); imshow(img);         title('Original Image');
    subplot(1,2,2); imshow(output_image); title(sprintf('Power Law (\\gamma=%.2f)', gamma));
end
