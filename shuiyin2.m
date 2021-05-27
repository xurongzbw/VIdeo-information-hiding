function [water_Img,K1,K2]=shuiyin2(img)
K1=15;
img=uint8(img);

Pimg=zeros(32,128,4);
img1=zeros(32,32,4);
img2=zeros(32,32,4);
img3=zeros(32,32,4);
img4=zeros(32,32,4);

for i=1:4
    Pimg(:,:,i)=img(32*(i-1)+1:32*i,:);
    for i1=1:4
    img1(:,:,i1)=Pimg(:,32*(i1-1)+1:32*i1,1);
    img2(:,:,i1)=Pimg(:,32*(i1-1)+1:32*i1,2);
    img3(:,:,i1)=Pimg(:,32*(i1-1)+1:32*i1,3);
    img4(:,:,i1)=Pimg(:,32*(i1-1)+1:32*i1,4);
    end
end
Wimg=cat(3,img1,img2,img3,img4);

Y=cell(1,16);
for j=1:16
    symbol_num=reshape(str2num(reshape(dec2bin(j,8),8,1)),1,8);
    Wimg(33,1:8,j)=symbol_num;
    Y{j}=Wimg(:,:,j);
end
K2=randperm(16);

for k=1:16
    water_img(:,:,k)=Y{K2(1,k)};
    water_Img(:,:,k)=water_img(1:32,:,k);
end

mkdir([cd,'/incept/Key']);%½¨Á¢Ä¿Â¼
x1=fopen('incept/Key/key1.txt','w');
fprintf(x1,'%s',K1);
fclose(x1);
x2=fopen('incept/Key/key2.txt','w');
fprintf(x2,'%s',K2);
fclose(x2);