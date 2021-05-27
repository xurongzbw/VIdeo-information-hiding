%img 灰度图像 a,b为参数 n为变换次数
function arnoldImg = arnold(img,n)
[h,w] = size(img);
N=h;
arnoldImg = zeros(h,w);
for i=1:n
    for y=1:h
        for x=1:w
            %防止取余过程中出现错误，先把坐标系变换成从0 到 N-1
            xx=mod((x-1)+1*(y-1),N)+1;
            yy=mod(1*(x-1)+(1*1+1)*(y-1),N)+1;  
            arnoldImg(yy,xx)=img(y,x);              
        end
    end
    img=arnoldImg;
end
arnoldImg = uint8(arnoldImg);
end