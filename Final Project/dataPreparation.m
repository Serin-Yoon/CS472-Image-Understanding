close all
clear all

masks = dir('/Users/serinyoon/Documents/MATLAB/Image Understanding/Final Project/PedMasks');
images = dir('/Users/serinyoon/Documents/MATLAB/Image Understanding/Final Project/PNGImages');

for i = 1 : 170
    mask = imread(strcat(masks(i+2).folder, '/', masks(i+2).name));
    img = imread(strcat(images(i+2).folder, '/', images(i+2).name));
        
    %figure(1), imagesc(mask)
    %figure(2), imagesc(img)

    peopleCnt = max(max(mask));

    % For every image
    for j = 1 : peopleCnt
        [row, col] = find(mask == j);

        minRow = min(row);
        maxRow = max(row);
        minCol = min(col);
        maxCol = max(col);

        % Create a Bounding Box (Just for a check)
        %img(minRow:maxRow, minCol) = 255;
        %img(minRow:maxRow, maxCol) = 255;
        %img(minRow, minCol:maxCol) = 255;
        %img(maxRow, minCol:maxCol) = 255;
        %figure(1 + i), image(img)

        % Crop Image
        croppedImg = imcrop(img, [minCol, minRow, maxCol - minCol, maxRow - minRow]);
        %figure(1 + i), imshow(croppedImg)

        % Resize Image & Save in 'croppedResizedImages' folder
        resizedImg = imresize(croppedImg, [128 64]);
        newPath = strcat('/Users/serinyoon/Documents/MATLAB/Image Understanding/Final Project/croppedResizedImages/person', extractBefore(masks(i+2).name, '_'), num2str(j), '.png');
        imwrite(resizedImg, newPath);
    end


    % Create no-person image
    cropSize = [90 45];
    for k = 1 : peopleCnt
        win = randomCropWindow2d(size(img), cropSize);
        imgCrop = imcrop(img, win);
        maskCrop = imcrop(mask, win);
    
        while (~isempty(find(maskCrop ~= 0, 1)))
            win = randomCropWindow2d(size(img), cropSize);
            imgCrop = imcrop(img, win);
            maskCrop = imcrop(mask, win);
        end

        % Resize Image & Save in 'noPersonImages' folder
        resizedImg = imresize(imgCrop, [128 64]);
        newPath = strcat('/Users/serinyoon/Documents/MATLAB/Image Understanding/Final Project/noPersonImages/noPerson', extractBefore(masks(i+2).name, '_'), num2str(k), '.png');
        imwrite(resizedImg, newPath);
    end

    %figure(1 + i), imshow(imgCrop);

end