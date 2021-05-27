function [ img ] = middle2filter(image)
    n = 3;
    [ h, w ] = size(image);
    x1 = double(image);
    x2 = x1;
    for i = 1: h-n+1
        for j = 1:w-n+1
            a = x1(i:(i+n-1),j:(j+n-1));
            a = a(:);
            b = median(a);
            x2(i+(n-1)/2,j+(n-1)/2) = b;
        end
    end
    img = uint8(x2);
end
