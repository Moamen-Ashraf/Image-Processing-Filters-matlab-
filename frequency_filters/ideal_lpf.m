function output_image = ideal_lpf(img, D0)
% IDEAL_LPF  Ideal Low-Pass Filter in the frequency domain.
%
%   output_image = ideal_lpf(img, D0)
%
%   Parameters:
%       img - Input grayscale image, uint8
%       D0  - Cutoff radius (pixels). Frequencies within D0 are kept.
%
%   Returns:
%       output_image - Filtered image, uint8
%
%   The ideal LPF transfer function:
%       H(u,v) = 1  if D(u,v) <= D0
%       H(u,v) = 0  otherwise
%   where D(u,v) is the distance from the spectrum centre.
%
%   Note: The sharp cutoff causes Gibbs (ringing) artefacts.
%
%   Example:
%       img = rgb2gray(imread('images/image.jpg'));
%       out = ideal_lpf(img, 30);

    FT  = fft2(double(img));
    FTS = fftshift(FT);

    [rows, cols] = size(FT);
    H = zeros(rows, cols);

    for u = 1 : rows
        for v = 1 : cols
            D = sqrt((u - rows/2)^2 + (v - cols/2)^2);
            if D <= D0
                H(u, v) = 1;
            end
        end
    end

    filtered  = ifftshift(H .* FTS);
    IFT       = ifft2(filtered);
    output_image = uint8(real(IFT));

    figure;
    subplot(1,2,1); imshow(img);          title('Original Image');
    subplot(1,2,2); imshow(output_image); title(sprintf('Ideal LPF (D_0=%d)', D0));
end
