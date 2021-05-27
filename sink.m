clear all;
clc;
close all;

%密钥提取
x1=fopen('incept\Key\key1.txt','r');
K1=abs(fread(x1,inf,'*char'));
fclose(x1);
x2=fopen('incept\Key\key2.txt','r');
K2=abs(fread(x2,inf,'*char'));
K2=reshape(K2,1,16);
fclose(x2);
filename1='incept\Key/key3.txt';
[data1,data2]=textread(filename1,'%f%f');
K3=reshape(data1,1,4);
K4=reshape(data2,1,4);
filename2='incept\Key/key4.txt';
data3=textread(filename2,'%d');
[Mq,Nq]=size(data3);
K5=reshape(data3,Nq,Mq);

Impor=K5;

%读取含水印的视频
[filename, filepath] = uigetfile('.avi', '输入含水印的视频');
videoFile = strcat(filepath, filename);
vd=VideoReader(videoFile);
vidFrames = read(vd);
NOF = get(vd, 'NumberOfFrames');  %获取视频帧数

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


%视频检测
[Impor_len]=ImportJiance(vd);
if  Impor_len<length(K5)-25
    disp('该视频缺失部分信息，请问是否继续提取')
    n=input('继续提取请输入1，重新上传文件请输入0:');
elseif Impor_len<16
    disp('该视频已损坏')
    n=0;
elseif Impor_len>length(K5)
    disp('该视频受到噪声攻击，请问是否继续提取')
    n=input('继续提取请输入2，重新上传文件请输入0:');
else
    n=1;
end

switch n
    
    case 2
        %秘密信息提取
        h=waitbar(0,'Dct提取');
        for j=1:length(K5)
            p=Impor(1,j);
            watermarkedImg= read(vd, p);
            [ water ] = tiqu(watermarkedImg,K3,K4);
            figure(1),imshow(water,[]);
            waterimg = rearnold(water,K1);
            figure(2),imshow(waterimg,[]);
            message(:,:,j)=waterimg;
            l=sprintf('秘密信息提取中，请稍后:%d',j);
            waitbar(j/length(K5),h,[l '/' num2str(length(K5))]);
            m(1,j)=mod(j,16);
            if m(1,j)==0
                m(1,j)=16;
            end
        end
        
        for xu=1:length(K5)
            message(33,1:8,xu)=reshape(str2num(reshape(dec2bin(K2(1,m(1,xu)),8),8,1)),1,8);
        end
        
        mkdir([cd,'/incept/result_attack_noise']);%建立目录
        directory=[cd,'/incept/result_attack_noise/'];
        g=sum(m(:)==16);
        h1=waitbar(0,'提取水印图像');
        for r = 1:g
            message_2=message(:,:,16*(r-1)+1:16*r);
            [reimg]=Dct_Tiqu(message_2);
            reimg = mat2gray(reimg);%图像矩阵的归一化操作
            imwrite(reimg,[directory,[num2str(r),'.bmp'];]);
            [ Reimg ] = middle2filter(reimg);
            Reimg = mat2gray(Reimg);%图像矩阵的归一化操作
            imwrite(Reimg,[directory,[num2str(r+11),'.bmp'];]);
            l1=sprintf('水印图像提取中，请稍后:%d',r);
            waitbar(r/g,h1,[l1 '/' num2str(g)]);
        end
    
    case 1
        %秘密信息提取
        h=waitbar(0,'Dct提取');
        for j=1:Impor_len
            p=Impor(1,j);
            watermarkedImg= read(vd, p);
            [ water ] = tiqu(watermarkedImg,K3,K4);
            figure(1),imshow(water,[]);
            waterimg = rearnold(water,K1);
            figure(2),imshow(waterimg,[]);
            message(:,:,j)=waterimg;
            l=sprintf('秘密信息提取中，请稍后:%d',j);
            waitbar(j/Impor_len,h,[l '/' num2str(Impor_len)]);
            m(1,j)=mod(j,16);
            if m(1,j)==0
                m(1,j)=16;
            end
        end
        
        for xu=1:Impor_len
            message(33,1:8,xu)=reshape(str2num(reshape(dec2bin(K2(1,m(1,xu)),8),8,1)),1,8);
        end
        
        mkdir([cd,'/incept/result']);%建立目录
        directory=[cd,'/incept/result/'];
        g=sum(m(:)==16);
        h1=waitbar(0,'提取水印图像');
        for r = 1:g
            message_2=message(:,:,16*(r-1)+1:16*r);
            [reimg]=Dct_Tiqu(message_2);
            reimg = mat2gray(reimg);%图像矩阵的归一化操作
            imwrite(reimg,[directory,[num2str(r),'.bmp'];]);
            l1=sprintf('水印图像提取中，请稍后:%d',r);
            waitbar(r/g,h1,[l1 '/' num2str(g)]);
        end
    case 0
        disp('请重新选择文件，感谢您的使用')
end
