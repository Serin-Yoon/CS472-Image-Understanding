img = imread('cameraman.jpeg');
[row, col] = size(cman);

% flip image
imgFlip = zeros(row, col);
for i = 1:row
    for j = 1:col
        imgFlip(i, j) = img(i, col - j + 1);
    end
end

subplot(1, 2, 1), imshow(img);
subplot(1, 2, 2), imshow(uint8(imgFlip));