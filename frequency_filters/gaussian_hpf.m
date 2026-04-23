function output_image = gaussian_hpf(img, D0)
% GAUSSIAN_HPF  Gaussian High-Pass Filter in the frequency domain.
%
%   output_image = gaussian_hpf(img, D0)
%
%   Parameters:
%       img - Input grayscale image, uint8
%       D0  - Cutoff frequency (controls the transition width)
%
%   Returns:
%       output_image - Filtered image, uint8
%
%   Transfer function:
%       H(u,v) = 1 - exp(-D^2 / (2 * D0^2))
%   which is the complement of the Gaussian LPF.
%
%   FIX: Original HPF_Gaussian.m called imshow(output) without ever
%        assigning the variable 'output'. Added:  output_image = uint8(real(IFT))
%
%   Example:
%       img = rgb2gray(imread('images/image.jpg'));
%       out = gaussian_hpf(img, 30);

    FT  = fft2(double(img));
    FTS = fftshift(FT);

    [rows, cols] = size(FT);
    H = zeros(rows, cols);

    for u = 1 : rows
        for v = 1 : cols
            D = sqrt((u - rows/2)^2 + (v - cols/2)^2);
            H(u, v) = 1 - exp(-D^2 / (2 * D0^2));   % HPF = 1 - GLPF
        end
    end

    filtered     = ifftshift(H .* FTS);
    IFT          = ifft2(filtered);
    output_image = uint8(real(IFT));   % FIX: was missing — caused runtime crash

    figure;
    subplot(1,2,1); imshow(img);          title('Original Image');
    subplot(1,2,2); imshow(output_image); title(sprintf('Gaussian HPF (D_0=%d)', D0));
end
