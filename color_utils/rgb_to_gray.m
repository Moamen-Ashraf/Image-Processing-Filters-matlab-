function rgb_to_gray(img)
% RGB_TO_GRAY  Convert an RGB image to grayscale using five different methods.
%
%   rgb_to_gray(img)
%
%   Parameters:
%       img  - Input RGB image, uint8
%
%   Displays five grayscale conversions side by side:
%       1. Single Channel     - Uses only the Red channel
%       2. Averaging          - (R + G + B) / 3
%       3. Luminance          - 0.299*R + 0.587*G + 0.114*B  (ITU-R BT.601)
%       4. Decomposition      - max(R, G, B)
%       5. Desaturation       - (max(R,G,B) + min(R,G,B)) / 2
%
%   Example:
%       img = imread('images/image.jpg');
%       rgb_to_gray(img);

    R = double(img(:,:,1));
    G = double(img(:,:,2));
    B = double(img(:,:,3));

    single_channel = uint8(R);
    averaging      = uint8((R + G + B) / 3);
    luminance      = uint8(0.299*R + 0.587*G + 0.114*B);
    decomposition  = uint8(max(max(R, G), B));
    desaturation   = uint8((max(max(R, G), B) + min(min(R, G), B)) / 2);

    figure('Name', 'RGB to Grayscale Methods');
    subplot(2,3,1); imshow(img);           title('Original RGB');
    subplot(2,3,2); imshow(single_channel); title('Single Channel (R)');
    subplot(2,3,3); imshow(averaging);      title('Averaging');
    subplot(2,3,4); imshow(luminance);      title('Luminance (ITU-R)');
    subplot(2,3,5); imshow(decomposition);  title('Decomposition (max)');
    subplot(2,3,6); imshow(desaturation);   title('Desaturation');
end
