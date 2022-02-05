img = imread('soul.jpeg');
[row, col, chan] = size(img);

% 1. get the red, green, blue values of a pixel
% 2. use weighted average formula to compute gray value
% 3. replace the original red, green, blue values with the new gray value

% Algorithm 1: RGB to Gray conversion by averaging R, G, B channels
imgGray1 = (double(img(:, :, 1)) + double(img(:, :, 2)) + double(img(:, :, 3))) ./ 3;

% Algorithm 2: RGB to Gray conversion with human perception formula 1
% (perception of human eye: Gray = Red * 0.3 + Green * 0.59 + Blue * 0.11)
imgGray2 = double(img(:, :, 1)) .* 0.3 + double(img(:, :, 2)) .* 0.59 + double(img(:, :, 3)) .* 0.11;

% Algorithm 3: RGB to Gray conversion with human perception formula 2
% (ITU-R: Gray = Red * 0.2126 + Green * 0.7152 + Blue * 0.0722)
imgGray3 = double(img(:, :, 1)) .* 0.2126 + double(img(:, :, 2)) .* 0.7152 + double(img(:, :, 3)) .* 0.0722;

subplot(2, 2, 1), imshow(img);
subplot(2, 2, 2), imshow(uint8(imgGray1));
subplot(2, 2, 3), imshow(uint8(imgGray2));
subplot(2, 2, 4), imshow(uint8(imgGray3));