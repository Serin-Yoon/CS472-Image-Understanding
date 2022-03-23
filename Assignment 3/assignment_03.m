clear all
close all

% --------------- Parameters --------------
Th1 = 0.1;      % All pixel gradient magnitudes below this threshold are ignored 
Th2 = 0.3;      % All pixel gradient magnitudes above this threshold are strong edge.
                
% Gaussian filter parameters used for image blurring
hsize = [5, 5];
sigma = 1;                

% Define discrete approximations (Sobel operator) of the partial derivatives
Gx = [-1 0 1; -2 0 2; -1 0 1];
Gy = [1 2 1; 0 0 0; -1 -2 -1];
% -------------------------------------------


% -------------------------------------------
% Step 1, Grayscale conversion
% The image is already grayscaled.
% Therefore loading of the image is sufficient

img = imread('cameraman.tif');
[row, col] = size(img);
figure(1), imshow(img, [])
% -------------------------------------------


% -------------------------------------------
% Step 2, Gaussian Blur
% Defined Gaussing filter is used for this.

h = fspecial('gaussian', hsize, sigma);
% Convolution with Gaussian filter for smoothing
Img_smth = conv2(double(img), h, 'same');
% -------------------------------------------


% -------------------------------------------
% Step 3, Compute Gradient Magnitude: 
% Perform partial derivative with respect to x and y directions.

Img_Gx = conv2(double(Img_smth), Gx, 'same');
Img_Gy = conv2(double(Img_smth), Gy, 'same');

% Approximation of gradient magnitude 
Img_mag = abs(Img_Gx) + abs(Img_Gy);

% Normalize the range of gradient magnitude to [0,1] 
maxGradient = max(max(Img_mag));
Img_mag = Img_mag ./ maxGradient; 
% -------------------------------------------


% ****************************************************
% Gradient orientation image.
% Each pixels of this image stored the gradient orientation
% (in angles between 0 to 90 and 0 to -90) of the respective pixel 
Img_orient = ( atan(Img_Gy ./ Img_Gx) .* 180 ) ./ pi;

Img_orient2 = zeros(row, col);
Img_orient2(Img_orient < 0) = 180;
Img_orient = Img_orient + Img_orient2;  % Gradient Orientation/Direction (range converted to 0 - 180 degree)

Img_edge = zeros(row, col);
Img_edgeThin = zeros(row, col);
Img_edgeStrong = zeros(row, col);
Img_edgeWeak  = zeros(row, col);
% ****************************************************


% -------------------------------------------
% Step 4, Non Maximum Suppression

Img_edge = Img_mag;
Img_edge(Img_edge < Th1) = 0; % Gradient Magnitude

Img_edgeThin = computeThinEdges(Img_edge, Img_orient, row, col);
figure(2), imshow(Img_edge, [])
figure(3), imshow(Img_edgeThin, [])
% -------------------------------------------
  

% -------------------------------------------
% Step 5, Double Thresholding

Img_edgeStrong = Img_edge;
Img_edgeStrong(Img_edgeThin == 0) = 0;
Img_edgeStrong(Img_edgeStrong <= Th2) = 0;
Img_edgeStrong(Img_edgeStrong > 0) = 255;

Img_edgeWeak = Img_edge;
Img_edgeWeak(Img_edgeThin == 0) = 0;
Img_edgeWeak(Img_edgeWeak < Th1 | Img_edgeWeak > Th2) = 0;
Img_edgeWeak(Img_edgeWeak > 0) = 255;

figure(4), imshow(Img_edgeStrong, [])
figure(5), imshow(Img_edgeWeak, [])
% -------------------------------------------


% -------------------------------------------
% Step 6, Edge Tracking by Hysteresis

Img_edgeStrong = weakEdgeConnect(Img_edgeStrong, Img_edgeWeak, Img_orient, row, col);
figure(6), imshow(Img_edgeStrong, []) % updated
% -------------------------------------------



% For Step 4 : Non Maximum Suppression
function Img_edgeThin = computeThinEdges(Img_edge, Img_orient, row, col)
    Img_edgeThin = zeros(row, col);

    for i = 2:row-1
        for j = 2:col-1

            if (Img_edge(i, j) > 0)
                if ((Img_orient(i, j) >= 0) && (Img_orient(i, j) < 22.5) || (Img_orient(i, j) >= 157.5 && Img_orient(i, j) <= 180))
                    green1 = Img_edge(i, j - 1);
                    green2 = Img_edge(i, j + 1);

                elseif (Img_orient(i, j) >= 22.5) && (Img_orient(i, j) < 67.5)
                    green1 = Img_edge(i - 1, j + 1);
                    green2 = Img_edge(i + 1, j - 1);
    
                elseif (Img_orient(i, j) >= 67.5 && Img_orient(i, j) < 112.5)
                    green1 = Img_edge(i - 1, j);
                    green2 = Img_edge(i + 1, j);
    
                elseif (Img_orient(i, j) >= 112.5 && Img_orient(i, j) < 157.5)
                    green1 = Img_edge(i - 1, j - 1);
                    green2 = Img_edge(i + 1, j + 1);
    
                end
    
                if ((Img_edge(i, j) >= green1) && (Img_edge(i, j) >= green2))
                    Img_edgeThin(i, j) = 255;
                end
            end
        end

    end
end

% For Step 6 : Edge Tracking by Hysteresis
function Img_edgeStrong = weakEdgeConnect(Img_edgeStrong, Img_edgeWeak, Img_orient, row, col)
    
    Edge_direction = Img_orient;
    Edge_direction2 = zeros(row, col);
    Edge_direction2(Edge_direction <= 90) = 90;
    Edge_direction2(Edge_direction > 90) = -90;
    Edge_direction = Edge_direction + Edge_direction2; % Edge Direction (range converted to 0 - 180 degree)

    for i = 2:row-1
        for j = 2:col-1

            % one of the green pixels should be strong & blue pixel should be weak

            if (Img_edgeWeak(i, j) > 0)

                if ((Edge_direction(i, j) >= 0) && (Edge_direction(i, j) < 22.5) || (Edge_direction(i, j) >= 157.5 && Edge_direction(i, j) <= 180))
                    green1 = Img_edgeStrong(i, j - 1);
                    green2 = Img_edgeStrong(i, j + 1);

                elseif (Edge_direction(i, j) >= 22.5) && (Edge_direction(i, j) < 67.5)
                    green1 = Img_edgeStrong(i - 1, j + 1);
                    green2 = Img_edgeStrong(i + 1, j - 1);
    
                elseif (Edge_direction(i, j) >= 67.5 && Edge_direction(i, j) < 112.5)
                    green1 = Img_edgeStrong(i - 1, j);
                    green2 = Img_edgeStrong(i + 1, j);
    
                elseif (Edge_direction(i, j) >= 112.5 && Edge_direction(i, j) < 157.5)
                    green1 = Img_edgeStrong(i - 1, j - 1);
                    green2 = Img_edgeStrong(i + 1, j + 1);
    
                end

                if (green1 > 0 || green2 > 0)
                    Img_edgeStrong(i, j) = 255;
                    Img_edgeWeak(i, j) = 0;
                end

            end
        end
    end

end