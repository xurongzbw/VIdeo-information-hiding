function [ water ] = tiqu(watermarked,k1,k2)

watermark = watermarked;
U_2=watermark(:,:,1);
after_2=blkproc(U_2,[4,4],'dct2');

p=zeros(1,4);
for i=1:32
    for j=1:32
        x=(i-1)*4;y=(j-1)*4;
        p(1)=after_2(x+1,y+4);
        p(2)=after_2(x+2,y+3);
        p(3)=after_2(x+3,y+2);
        p(4)=after_2(x+4,y+1);
%         p(5)=after_2(x+5,y+4);
%         p(6)=after_2(x+6,y+3);
%         p(7)=after_2(x+7,y+2);
%         p(8)=after_2(x+8,y+1);
        if corr2(p,k1)>corr2(p,k2)
            water(i,j)=1;
        else
            water(i,j)=0;
        end
    end
end
% global pathfile4;
% global pathfre;
% pathfile4=fullfile(pathfre, 'randmark.bmp');

end