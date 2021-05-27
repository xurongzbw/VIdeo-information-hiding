%计算关键帧位置
function Impor=Important2Zhen(video)
obj = video;%输入视频位置
NOF=obj.NumberOfFrames;% 帧的总数
mkdir([cd,'/test_images']);%建立目录
directory=[cd,'/test_images/'];

for i=1:NOF
    Img_I=read(obj,i); %读取视频
    imwrite(Img_I,[directory,[num2str(i) '.bmp'];]);   %每一帧输出一张jpg
end; 
              
file_path =  'test_images\';% 图像文件夹路径
img_path_list = dir(strcat(file_path,'*.bmp'));%获取该文件夹中所有jpg格式的图像

for i=1:NOF-1
    image_name_i = strcat(num2str(i),'.bmp');  %图像名
    img_i =  imread(strcat(file_path,image_name_i));  %读取该图像
    image_name_i_plus = strcat(num2str(i+1),'.bmp');% 后一张图像名
    img_i_plus =  imread(strcat(file_path,image_name_i_plus));  %读取后一张图像
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

x3=fopen('incept/Key/key4.txt','w');                 %打开文件 返回文件id号  
fprintf(x3,'%d\n',Impor);             %输出集合数组data
fclose(x3);                           %关闭文件