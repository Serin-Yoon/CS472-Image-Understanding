%% Histogram equalization on a gray scale image

% Low Contrast Image
imGray = imread('valley.png');

% Histogram H(i)
hist_lowContrast = my_histogram(imGray);

% Cumulative Histogram C(i)
hist_cumulative = cumulative_hist(hist_lowContrast);

% Equalized Histogram
[hist_eq, map_table] = my_histeq(hist_lowContrast, hist_cumulative);

% Contrast Enhanced Image
imGray_highContrast = my_contrastEnhance(imGray, map_table);
