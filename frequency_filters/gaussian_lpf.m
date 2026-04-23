function output_image = gaussian_lpf(img, D0)
% GAUSSIAN_LPF  Gaussian Low-Pass Filter in the frequency domain.
%
%   output_image = gaussian_lpf(img, D0)
%
%   Parameters:
%       img - Input grayscale image, uint8
%       D0  - Cutoff frequency (standard deviation of the Gaussian in pixels)
%
%   Returns:
%       output_image - Filtered image, uint8
%
%   Transfer function:
%       H(u,v) = exp(-D^2 / (2 * D0^2))
%
%   The Gaussian LPF has no ringing artefacts because the Fourier
%   transform of a Gaussian is itself a Gaussian.
%
%   Example:
%       img = rgb2gray(imread('images/image.jpg'));
%       out = gaussian_lpf(img, 30);

    FT  = fft2(double(img));
    FTS = fftshift(FT);

    [rows, cols] = size(FT);
    H = zeros(rows, cols);

    for u = 1 : rows
        for v = 1 : cols
            D = sqrt((u - rows/2)^2 + (v - cols/2)^2);
            H(u, v) = exp(-D^2 / (2 * D0^2));
        end
    end

    filtered     = ifftshift(H .* FTS);
    IFT          = ifft2(filtered);
    output_image = uint8(real(IFT));

    figure;
    subplot(1,2,1); imshow(img);          title('Original Image');
    subplot(1,2,2); imshow(output_image); title(sprintf('Gaussian LPF (D_0=%d)', D0));
end
