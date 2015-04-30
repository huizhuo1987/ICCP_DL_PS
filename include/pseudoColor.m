function normalShow = pseudoColor(normalMap)
[m, n, h] = size(normalMap);
normalShow = zeros(size(normalMap));
for i = 1 : m
    for j = 1 : n
        x1 = normalMap(i,j,1);
        x2 = normalMap(i,j,2);
        x3 = normalMap(i,j,3);
        if x1 == 0 && x2 == 0 && x3 == 0
            normalShow(i,j,:) = 0;
        else
            x123sum = sqrt(x1^2 + x2^2 + x3^2);
            Red = (x1/x123sum + 1) * 128;
            Green = (x2/x123sum + 1) * 128;
            Blue = (x3/x123sum + 1) * 128;
            color = [Red Green  Blue]';
            normalShow(i,j,:) = color./norm(color);
        end        
    end
end
