test_image = im2single(imread('../questions/RISDance.jpg'));

size_arr = [0.03125, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
x = [];
y = [];
z = [];
for i = 3:15
    for j = 1:12
        filter = fspecial('Gaussian', [i i], 10);
        img = imresize(test_image, size_arr(j));
        tstart = tic;
        imfilter(img, filter, 'conv');
        telapsed = toc(tstart);
        disp(telapsed);
        x = [x i];
        y = [y (size_arr(j) * 8)];
        z = [z telapsed];
    end
end

scatter3(x, y, z, 'filled');