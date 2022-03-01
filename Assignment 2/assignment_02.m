%% Bilateral Image Filtering

% Load Image
imgColor = imread('Lena_color.png');
img = rgb2gray(imgColor);
imgNoise = imnoise(img, 'gaussian', 0, 0.003);

% Spatial Gaussian Filter
hsize = [5, 5];
sigma = 30;
spatialFilter = fspecial('gaussian', hsize, sigma);

% Zero Padded Image
[Ix, Iy, Ch] = size(imgNoise);
Px = (hsize(1) - 1) ./ 2;
Py = (hsize(2) - 1) ./ 2;
Ix_pad = Ix + 2 * Px;
Iy_pad = Iy + 2 * Py;
imgPad = zeros(Ix_pad, Iy_pad);
imgPad((Px + 1):(Ix + Px), (Py + 1):(Iy + Py)) = imgNoise;

% Range Filter & Bilateral Filter
patchsize = [5, 5];
filteredImg = zeros(Ix, Iy);
for x = 1:Ix
    for y = 1:Iy
        patch = imgPad(x:(x + patchsize(1) - 1), y:(y + patchsize(2) - 1));
        centerPixel = patch(fix(patchsize(1) ./ 2) + 1, fix(patchsize(2) ./ 2) + 1);
        patchDiff = patch - centerPixel;
        rangeFilter = exp(-(patchDiff .* patchDiff) ./ (2 * sigma * sigma));
        bilatFilter = rangeFilter .* spatialFilter;
        bilatFilter = bilatFilter / sum(bilatFilter(:));
        tmp = imgPad(x:(x + patchsize(1) - 1), y:(y + patchsize(2) - 1)) .* bilatFilter;
        filteredImg(x, y) = sum(tmp(:));
    end
end

% Orignial Image & Padded Image & Filtered Image
figure(1), imshow(imgNoise);
figure(2), imshow(uint8(imgPad));
figure(3), imshow(uint8(filteredImg));