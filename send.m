clear all;
clc;
close all;
[filename, filepath] = uigetfile('.bmp', '请输入BMP格式水印');
watermarkImgFile = strcat(filepath, filename);
mark=imread(watermarkImgFile);
[water_Img,K1,K2]=shuiyin2(mark);

%读入视频
[filename, filepath] = uigetfile('.avi', '请输入AVI格式的载体视频');
videoFile = strcat(filepath, filename);
vd=VideoReader(videoFile);
vidFrames = read(vd);
NOF = get(vd, 'NumberOfFrames');  %获取视频帧数
Impor=Important2Zhen(vd);
Impor_len=length(Impor);

%显示播放视频
for u = 1 : NOF
    mov(u).cdata = vidFrames(:,:,:,u);
    mov(u).colormap = [];
end

% 创建显示句柄
mp4 = figure;
% 设置自适应视频宽高
set(mp4, 'position', [150 150 vd.Width vd.Height])
%播放视频内容
movie(mp4, mov, 1, vd.FrameRate);

%视频秘密信息嵌入
directory=[cd,'/test_images/'];
K3=randn(1,4);  %产生两个不同的随机序列
K4=randn(1,4);
mark_2=zeros(32,32);

h=waitbar(0,'Dct嵌入');
for i=1:Impor_len
    e=Impor(1,i);
    currentFrame = read(vd, e);%读取帧
    m(1,i)=mod(i,16);
    if m(1,i)==0
        m(1,i)=16;
    end
    mark_2=water_Img(:,:,m(1,i));
    arnoldImg = arnold(mark_2,K1);
    figure(1),imshow(mark_2,[]);
    figure(2),imshow(arnoldImg,[]);
    [waterimage] = qianru( currentFrame,arnoldImg,K3,K4 );
    imwrite(waterimage,[directory,[num2str(e),'.bmp'];]); 
    s=sprintf('秘密信息嵌入中，请稍后:%d',i);
    waitbar(i/Impor_len,h,[s '/' num2str(Impor_len)]);
end

%生成新视频
path = 'test_images\';                  
writerObj = VideoWriter('incept/result.avi');   %将生成的视频保存
open(writerObj);
for f = 1:NOF
   frame = imread(strcat(path,num2str(f),'.bmp'));
   writeVideo(writerObj,frame);
end
close(writerObj);

key_data=[K3;K4];
Key3=fopen('incept/Key/key3.txt','w');                 
fprintf(Key3,'%.15f %.15f\n',key_data);             
fclose(Key3);                           

