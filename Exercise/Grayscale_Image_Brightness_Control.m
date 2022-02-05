% Adding a fixed value to each pixel. 

value = 50; % value can be a positive/negative value
img = imread('jojorabbit.jpeg');
imgGray = rgb2gray(img);

imgGrayUpdate = double(imgGray) + value;
imgGrayUpdate(imgGrayUpdate < 0) = 0;
imgGrayUpdate(imgGrayUpdate > 255) = 255;
figure(1), imshow(uint8(imgGray));
figure(2), imshow(uint8(imgGrayUpdate));