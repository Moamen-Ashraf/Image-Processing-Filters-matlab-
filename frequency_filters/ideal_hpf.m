function output_image = ideal_hpf(img, D0)
% IDEAL_HPF  Ideal High-Pass Filter in the frequency domain.
%
%   output_image = ideal_hpf(img, D0)
%
%   Parameters:
%       img - Input grayscale image, uint8
%       D0  - Cutoff radius (pixels). Frequencies beyond D0 are kept.
%
%   Returns:
%       output_image - Filtered image, uint8
%
%   Transfer function:
%       H(u,v) = 0  if D(u,v) <= D0
%       H(u,v) = 1  otherwise
%
%   Example:
%       img = rgb2gray(imread('images/image.jpg'));
%       out = ideal_hpf(img, 30);

    FT  = fft2(double(img));
    FTS = fftshift(FT);

    [rows, cols] = size(FT);
    H = zeros(rows, cols);

    for u = 1 : rows
        for v = 1 : cols
            D = sqrt((u - rows/2)^2 + (v - cols/2)^2);
            if D > D0
                H(u, v) = 1;
            end
        end
    end

    filtered     = ifftshift(H .* FTS);
    IFT          = ifft2(filtered);
    output_image = uint8(real(IFT));

    figure;
    subplot(1,2,1); imshow(img);          title('Original Image');
    subplot(1,2,2); imshow(output_image); title(sprintf('Ideal HPF (D_0=%d)', D0));
end
