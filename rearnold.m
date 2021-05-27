function img = rearnold(arnoldImg,n)
[h,w] = size(arnoldImg);
img = zeros(h,w);
N = h;
for i=1:n
    for y=1:h
        for x=1:w           
            xx=mod((1*1+1)*(x-1)-1*(y-1),N)+1;
            yy=mod(-1*(x-1)+(y-1),N)+1  ;      
            img(yy,xx)=arnoldImg(y,x);              
        end
    end
    arnoldImg=img;
end
img = uint8(img);
end