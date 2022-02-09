function imGray_highContrast = my_contrastEnhance(imGray, map_table)

[row, column, channel] = size(imGray);

for x = 1:row
    for y = 1:column
        tmp = imGray(x, y);
        imGray_highContrast(x, y, :) = map_table(tmp, 1);
    end
end

figure(6), imshow(uint8(imGray_highContrast))

end