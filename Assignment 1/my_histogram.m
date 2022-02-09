function hist_lowContrast = my_histogram(imGray)

% hist_lowContrast should be a row vector of size 1x256, where i'th value of the vector
% is the count of image pixels with grayscale value 'i-1'. 

hist_lowContrast = imhist(imGray);
grayRange = 0:1:255;

figure(1), imshow(imGray);
figure(2), bar(grayRange, hist_lowContrast);

end