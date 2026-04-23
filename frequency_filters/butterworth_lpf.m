function output_image = butterworth_lpf(img, D0, n)
% BUTTERWORTH_LPF  Butterworth Low-Pass Filter in the frequency domain.
%
%   output_image = butterworth_lpf(img, D0, n)
%
%   Parameters:
%       img - Input grayscale image, uint8
%       D0  - Cutoff frequency (distance from centre in pixels)
%       n   - Filter order (higher = sharper transition)
%
%   Returns:
%       output_image - Filtered image, uint8
%
%   Transfer function:
%       H(u,v) = 1 / (1 + (D/D0)^(2n))
%
%   Unlike the ideal LPF, the Butterworth filter has a smooth transition
%   that avoids Gibbs ringing artefacts.
%
%   Example:
%       img = rgb2gray(imread('images/image.jpg'));
%       out = butterworth_lpf(img, 30, 2);

    FT  = fft2(double(img));
    FTS = fftshift(FT);

    [rows, cols] = size(FT);
    H = zeros(rows, cols);

    for u = 1 : rows
        for v = 1 : cols
            D = sqrt((u - rows/2)^2 + (v - cols/2)^2);
            H(u, v) = 1 / (1 + (D / D0)^(2 * n));
        end
    end

    filtered     = ifftshift(H .* FTS);
    IFT          = ifft2(filtered);
    output_image = uint8(real(IFT));

    figure;
    subplot(1,2,1); imshow(img);          title('Original Image');
    subplot(1,2,2); imshow(output_image); title(sprintf('Butterworth LPF (D_0=%d, n=%d)', D0, n));
end
