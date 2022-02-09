function hist_cumulative = cumulative_hist(hist_lowContrast)

N = sum(hist_lowContrast);

% Probability Distribution Function - hist_lowContrast2
for i = 1:256
    hist_lowContrast2(i, 1) = hist_lowContrast(i, 1) ./ N;
end

grayRange = 0:1:255;
figure(3), bar(grayRange, hist_lowContrast2);

% Cumulative Distribution Function - hist_cumulative
for i = 1:256
    j = 1:i;
    hist_cumulative(i, 1) = sum(hist_lowContrast2(j, 1));
end

figure(4), bar(grayRange, hist_cumulative);