function [hist_eq, map_table] = my_histeq(hist_lowContrast, hist_cumulative)

for i = 1:256
    map_table(i, 1) = ceil(hist_cumulative(i, 1) * 255);
end

for i = 1:256
    hist_eq(map_table(i, 1) + 1, 1) = hist_lowContrast(i, 1);
end

grayRange = 0:1:255;
figure(5), bar(grayRange, hist_eq)

end