personFeatureVectAll = zeros(423, 3780); % 256 * 3 * 2 = 1536 -> error
noPersonFeatureVectAll = zeros(423, 3780);

% Load Person & No-Person Images
personImgs = dir('/Users/serinyoon/Documents/MATLAB/Image Understanding/Final Project/croppedResizedImages');
noPersonImgs = dir('/Users/serinyoon/Documents/MATLAB/Image Understanding/Final Project/noPersonImages');

for i = 1 : 423
    personImg = imread(strcat(personImgs(i+2).folder, '/', personImgs(i+2).name));
    noPersonImg = imread(strcat(noPersonImgs(i+2).folder, '/', noPersonImgs(i+2).name));

    % Extract HOG features for each image
    [personFeatureVector, hogVisualization1] = extractHOGFeatures(personImg);
    personFeatureVectAll(i, :) = personFeatureVector;
    [noPersonFeatureVector, hogVisualization2] = extractHOGFeatures(noPersonImg);
    noPersonFeatureVectAll(i, :) = noPersonFeatureVector;
end

dataCnt = 423;
allIdx = 1:1:dataCnt;

% 10 fold cross validation
crossValCnt = 10;
lastEnd = 0;
errSum = 0;
sampleSum = 0;

for i = 1:crossValCnt
    startIdx = lastEnd + 1;
    endIdx = round(dataCnt * (i / crossValCnt));

    testData = personFeatureVectAll(startIdx:endIdx, :);
    testData = [testData; noPersonFeatureVectAll(startIdx:endIdx, :)];

    testIdx = startIdx:1:endIdx;
    trainIdx = setdiff(allIdx, testIdx);
    
    trainingData = personFeatureVectAll(trainIdx, :);
    trainingData = [trainingData; noPersonFeatureVectAll(trainIdx, :)];

    Y_train = [ones(length(trainIdx), 1); 2 * ones(length(trainIdx), 1)];
    Y_test = [ones(length(testIdx), 1); 2 * ones(length(testIdx), 1)];


    SVMModel = fitcsvm(trainingData, Y_train, 'Standardize', true, 'KernelFunction', 'RBF', 'KernelScale', 'auto');
    [~, score] = predict(SVMModel, testData);
    result = score(:, 1) - score(:, 2);
    result(result >= 0) = 1;
    result(result ~= 1) = 2;

    errSum = errSum + sum(abs(result - Y_test));
    sampleSum = sampleSum + length(Y_test);

    lastEnd = endIdx;
end

disp(['Average error on full data set is ', num2str(100 * (errSum / sampleSum))]);