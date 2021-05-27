function [waterimage] = qianru( img,water,k1,k2 )

carry = img;
water = water;
mark = uint8(water);
%watermark = rgb2gray(water);
% mark = im2bw(watermark);

marksize = size(mark);
rm = marksize(1);
cm = marksize(2);

I = mark;
alpha=15;

yuv=rgb2ycbcr(carry);
Y=yuv(:,:,1);
U=yuv(:,:,2);
V=yuv(:,:,3);
before=blkproc(Y,[4 4],'dct2');

after=before;
for i=1:rm
    for j=1:cm
        x=(i-1)*4;
        y=(j-1)*4;
        if mark(i,j)==1
            k=k1;
        else
            k=k2;
        end;
        after(x+1,y+4)=before(x+1,y+4)+alpha*k(1);
        after(x+2,y+3)=before(x+2,y+3)+alpha*k(2);
        after(x+3,y+2)=before(x+3,y+2)+alpha*k(3);
        after(x+4,y+1)=before(x+4,y+1)+alpha*k(4);
%         after(x+5,y+4)=before(x+5,y+4)+alpha*k(5);
%         after(x+6,y+3)=before(x+6,y+3)+alpha*k(6);
%         after(x+7,y+2)=before(x+7,y+2)+alpha*k(7);
%         after(x+8,y+1)=before(x+8,y+1)+alpha*k(8);
    end;
end;
result=blkproc(after,[4 4],'idct2');
yuv_after=cat(3,result,U,V);
waterimage=ycbcr2rgb(yuv_after);

% global pathfile3;
% global pathfre;
% pathfile3=fullfile(pathfre, 'waterimage.bmp');


end