% Load a classifier
trainingData = [personFeatureVectAll; noPersonFeatureVectAll];
Y_train = [ones(dataCnt, 1); 2 * ones(dataCnt, 1)];

slidingWindow = [300 80];
winCnt = size(slidingWindow, 1);

SVMModelTest = fitcsvm(trainingData, Y_train, 'Standardize', true, 'KernelFunction', 'RBF', 'KernelScale', 'auto');

personTestPath = '/Users/serinyoon/Documents/MATLAB/Image Understanding/Final Project/testData';
fileAll_personTest = dir(personTestPath);
testCnt = size(fileAll_personTest, 1) - 2;

for i = 1:testCnt
    imgPath = strcat(strcat(personTestPath, '/'), fileAll_personTest(i + 2).name);
    img = imread(imgPath); % Load test image
    [row col chan] = size(img);
    figure(1), imshow(img);

    hold on

    if (chan == 3)
        imgGray = rgb2gray(img);
    else
        disp('ERROR! Incorrect image format.')
    end

    % Move a sliding window
    for w = 1:winCnt
        for r = 1 : 5 : (row - slidingWindow(w, 1) + 1)
            for c = 1 : 5 : (col - slidingWindow(w, 2) + 1)

                % Crop the image inside the window
                imgWindow = imgGray(r : r + slidingWindow(w, 1) - 1, c : c + slidingWindow(w, 2) - 1);
                % Resize it to 128x64
                resizedImg = imresize(imgWindow, [128 64]);
                % Extract the HOG feature vector
                testFeatureVect = extractHOGFeatures(resizedImg);
                    
                [~, score] = predict(SVMModelTest, testFeatureVect);

                if (score(1) > 0)
                    rectangle('Position',[c r slidingWindow(w, 2) slidingWindow(w, 1)],'Curvature',0.2, 'EdgeColor', 'g')
                end
            end
        end
        hold off
    end
end