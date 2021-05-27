function [Impor_len]=ImportJiance(video)
obj = video;%输入视频位置
NOF=obj.NumberOfFrames;% 帧的总数

for i=1:NOF-1
    img_i =  read(obj,i);  %读取该图像
    j=i+1;
    img_i_plus =  read(obj,j);  %读取后一张图像
    img_sim(i)=corr2(img_i(:,:,1),img_i_plus(:,:,1))+corr2(img_i(:,:,2),img_i_plus(:,:,2))+corr2(img_i(:,:,3),img_i_plus(:,:,3));  %计算前后两张图像的相似度
    img_sim(i)=img_sim(i)/3;
end;
Y_val=mean(img_sim(1,:));
Threshold=Y_val;              %相似度阈值
Impor=[];
for i=1:length(img_sim)
    if(img_sim(i)<Threshold)    %如果相似度小于阈值，则说明与后一张图像不相似，则判定为镜头切换帧
        Impor=[Impor,i]; %输出帧编号
    end;
end;
Impor_len=length(Impor);