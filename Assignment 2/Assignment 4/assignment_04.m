clear all
close all

segTh = 20;     % Threshold for boundary pixels
segThSeed = 30; % Threshold for original seed pixel 
cnt = 0;

cMan = imread('cameraman.tif');

[row, col, chan] = size(cMan);
if(chan > 1)
    cMan = rgb2gray(cMan);
end    

% Select Seed point
figure(1), imshow(cMan, []);
hold on
[X, Y] = ginput(1); % X: col, Y: row
hold off
X = round(X);
Y = round(Y);
seed = {[X, Y]}; % ㅣist variable that can grow within the program

% Loops for Region Growing
travarseImg = zeros(row, col);
travarseImg(Y, X) = 1;          % Initialize the seed point
seedVal = double(cMan(Y, X));   % Initial seed gray value

while(~isempty(seed))
    X = seed{1}(1);
    Y = seed{1}(2);

    for i = -1:1
        for j = -1:1
            if (X+j > 0 && X+j <= col && Y+i > 0 && Y+i <= row)
                if (~travarseImg(Y+i, X+j) && abs(double(cMan(Y+i, X+j)) - double(cMan(Y, X))) < segTh && abs(double(cMan(Y+i, X+j)) - seedVal) < segThSeed)
                    seed{end+1} = [X+j, Y+i];
                    travarseImg(Y+i, X+j) = 1;
                end
            end
        end
    end
    
    seed(1) = [];
end

figure(2), imshow(travarseImg, [])
cManColor = zeros(row, col, 3); 
cManColor(:, :, 1) = cMan;
cManColor(:, :, 2) = cMan;
cManColor(:, :, 3) = cMan;
cManColor(:, :, 1) = cManColor(:, :, 1) + (travarseImg .* 50);
cManColor(cManColor > 255) = 255;
figure(3), imshow(uint8(cManColor))

