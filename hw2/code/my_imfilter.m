function output = my_imfilter(image, filter, isfft)
% This function is intended to behave like the built in function imfilter()
% when operating in convolution mode. See 'help imfilter'. 
% While "correlation" and "convolution" are both called filtering, 
% there is a difference. From 'help filter2':
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.

% Your function should meet the requirements laid out on the project webpage.

% Boundary handling can be tricky as the filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% we look at 'help imfilter', we see that there are several options to deal 
% with boundaries. 
% Please recreate the default behavior of imfilter:
% to pad the input image with zeros, and return a filtered image which matches 
% the input image resolution. 
% A better approach is to mirror or reflect the image content in the padding.

% Uncomment to call imfilter to see the desired behavior.
% output = imfilter(image, filter, 'conv');

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%

if ~exist('isfft', 'var')
    isfft = 0;
end

[m, n] = size(image(:,:,1));
[m_, n_] = size(filter); 

if (mod(m_, 2) == 0 || mod(n_, 2) == 0)
    error('Invalid filter: Even dimension');
end

pad_m = (m_ - 1) ./ 2;
pad_n = (n_ - 1) ./ 2;

M = m + pad_m * 2;
N = n + pad_n * 2;

reflected_image = padarray(image, [pad_m pad_n 0], 'symmetric', 'both');

if (isfft == 1)
    low_pass_image = ifft2(fft2(reflected_image) .* fft2(filter, M, N));

    output = real(low_pass_image(m_ : (m + m_ - 1), n_ : (n + n_ - 1), :));
else
    filter = flipud(fliplr(filter));
    temp = zeros([M N 3]);
    for i = 1:3
        for x = pad_m + 1 : (pad_m + m)
            for y = pad_n + 1 : (pad_n + n)
                for k = -1 * pad_m : pad_m
                    for l = -1 * pad_n : pad_n
                        reflected_image(x + k, y + l, i);
                        filter(k + pad_m + 1, l + pad_n + 1);
                        temp(x, y, i) = temp(x, y, i) + reflected_image(x + k, y + l, i) * filter(k + pad_m + 1, l + pad_n + 1);
                    end
                end
            end
        end
    end

    output = real(temp(pad_m + 1: (m + pad_m), pad_n + 1 : (n + pad_n), :));
end