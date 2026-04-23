function output_image = histogram_matching(source_img, reference_img)
% HISTOGRAM_MATCHING  Match the histogram of a source image to a reference image.
%
%   output_image = histogram_matching(source_img, reference_img)
%
%   Parameters:
%       source_img    - Image whose histogram will be modified (grayscale or RGB)
%       reference_img - Image whose histogram shape will be targeted (grayscale or RGB)
%
%   Returns:
%       output_image  - Source image with matched histogram, uint8
%
%   Algorithm:
%       1. Compute CDFs of both source and reference images.
%       2. For each source intensity r, find reference intensity s such that
%          CDF_ref(s) is closest to CDF_src(r).
%
%   FIX: Original file had a second unrelated function body pasted inside it,
%        making it invalid MATLAB. Removed the duplicate. Also added proper
%        two-image interface — the original only accepted one argument.
%
%   Example:
%       src = imread('images/image.jpg');
%       ref = imread('images/image1.jpg');
%       out = histogram_matching(src, ref);

    % Convert to grayscale if needed
    if size(source_img, 3) == 3,    source_img    = rgb2gray(source_img);    end
    if size(reference_img, 3) == 3, reference_img = rgb2gray(reference_img); end

    % --- CDF of source ---
    [rs, cs] = size(source_img);
    total_s  = rs * cs;
    pdf_s    = zeros(1, 256);
    for i = 1:rs
        for j = 1:cs
            pdf_s(source_img(i,j)+1) = pdf_s(source_img(i,j)+1) + 1;
        end
    end
    pdf_s = pdf_s / total_s;
    cdf_s = cumsum(pdf_s);

    % --- CDF of reference ---
    [rr, cr] = size(reference_img);
    total_r  = rr * cr;
    pdf_r    = zeros(1, 256);
    for i = 1:rr
        for j = 1:cr
            pdf_r(reference_img(i,j)+1) = pdf_r(reference_img(i,j)+1) + 1;
        end
    end
    pdf_r = pdf_r / total_r;
    cdf_r = cumsum(pdf_r);

    % --- Build mapping: for each source intensity find best reference intensity ---
    mapping = zeros(1, 256);
    for src_val = 1 : 256
        [~, best] = min(abs(cdf_r - cdf_s(src_val)));
        mapping(src_val) = best - 1;   % convert back to 0-based intensity
    end

    % --- Apply mapping ---
    output_image = uint8(mapping(double(source_img) + 1));

    figure;
    subplot(1,3,1); imshow(source_img);    title('Source Image');
    subplot(1,3,2); imshow(reference_img); title('Reference Image');
    subplot(1,3,3); imshow(output_image);  title('Histogram Matched');
end
