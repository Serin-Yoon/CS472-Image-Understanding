% Adding a fixed value to all 3 channels of each pixel.

value = 50;
img = imread('jojorabbit.jpeg');

imgUpdate = double(img) + value;
imgUpdate(imgUpdate < 0) = 0;
imgUpdate(imgUpdate > 255) = 255;
figure(1), imshow(uint8(img));
figure(2), imshow(uint8(imgUpdate));

% problem: ex) red[150, 0, 0] => not red[230, 80, 80]
% solution: transform a color image into HSV space, adjust the brightness
% in HSV space, and transform the result back into RGB color space

imgHSV = rgb2hsv(img);
imgHSV(:, :, 3) = imgHSV(:, :, 3) .* 0.5;
imgRGB = hsv2rgb(imgHSV);
figure(3), imshow(img);
figure(4), imshow(imgRGB);

% Image Brightness Control

subplot(2, 5, 1), imshow(img);

count = 1;
for i = 0.1:0.2:0.8
    imgHSV = rgb2hsv(img);
    value = imgHSV(:, :, 3) + i;
    value(value > 1) = 1;
    imgHSV(:, :, 3) = value;
    imgRGB = hsv2rgb(imgHSV);
    count = count + 1;
    subplot(2, 5, count), imshow(imgRGB);
end

for i = 0.1:0.2:1
    imgHSV = rgb2hsv(img);
    value = imgHSV(:, :, 3) - i;
    value(value < 0) = 0;
    imgHSV(:, :, 3) = value;
    imgRGB = hsv2rgb(imgHSV);
    count = count + 1;
    subplot(2, 5, count), imshow(imgRGB);
end