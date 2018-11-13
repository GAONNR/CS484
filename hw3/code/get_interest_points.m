% Local Feature Stencil Code
% Written by James Hays for CS 143 @ Brown / CS 4476/6476 @ Georgia Tech

% Returns a set of interest points for the input image

% 'image' can be grayscale or color, your choice.
% 'descriptor_window_image_width', in pixels.
%   This is the local feature descriptor width. It might be useful in this function to 
%   (a) suppress boundary interest points (where a feature wouldn't fit entirely in the image, anyway), or
%   (b) scale the image filters being used. 
% Or you can ignore it.

% 'x' and 'y' are nx1 vectors of x and y coordinates of interest points.
% 'confidence' is an nx1 vector indicating the strength of the interest
%   point. You might use this later or not.
% 'scale' and 'orientation' are nx1 vectors indicating the scale and
%   orientation of each interest point. These are OPTIONAL. By default you
%   do not need to make scale and orientation invariant local features.
function [x, y, confidence, scale, orientation] = get_interest_points(image, descriptor_window_image_width)

% Implement the Harris corner detector (See Szeliski 4.1.1) to start with.
% You can create additional interest point detector functions (e.g. MSER)
% for extra credit.

% If you're finding spurious interest point detections near the boundaries,
% it is safe to simply suppress the gradients / corners near the edges of
% the image.

% The lecture slides and textbook are a bit vague on how to do the
% non-maximum suppression once you've thresholded the cornerness score.
% You are free to experiment. Here are some helpful functions:
%  BWLABEL and the newer BWCONNCOMP will find connected components in 
% thresholded binary image. You could, for instance, take the maximum value
% within each component.
%  COLFILT can be used to run a max() operator on each sliding window. You
% could use this to ensure that every interest point is at a local maximum
% of cornerness.

first_blur = fspecial('gaussian', [4 4], 1);
blurred_img = imfilter(image, first_blur, 'conv');
[Ix Iy] = imgradientxy(blurred_img);

padding = ceil(descriptor_window_image_width / 2);

gaussian_kernel = fspecial('gaussian', [16 16], 1);

Ix2 = imfilter(Ix .^ 2, gaussian_kernel, 'conv');
Iy2 = imfilter(Iy .^ 2, gaussian_kernel, 'conv');
IxIy = imfilter(Ix .* Iy, gaussian_kernel, 'conv');

ALPHA = 0.04;
C = Ix2 .* Iy2 - (IxIy .^ 2) - ALPHA * ((Ix2 + Iy2) .^ 2);
C(1 : padding, :) = 0;
C(:, 1 : padding) = 0;
C(end - padding + 1 : end, :) = 0;
C(:, end - padding + 1 : end) = 0;

localmaxima_C = zeros(size(C));
WINSIZE = 2;

for i = 1 + WINSIZE : size(C, 1) - WINSIZE
    for j = 1 + WINSIZE : size(C, 2) - WINSIZE
        tmp_window = C(i - WINSIZE : i + WINSIZE, j - WINSIZE : j + WINSIZE);
        local_maxima = max(tmp_window(:));
        if C(i, j) == local_maxima
            localmaxima_C(i, j) = C(i, j);
        end
    end
end

THRESHOLD = 30 * mean2(localmaxima_C);
[y x] = find(localmaxima_C > THRESHOLD);
length(x)

end

