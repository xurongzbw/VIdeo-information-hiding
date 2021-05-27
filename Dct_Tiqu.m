function [reimg]=Dct_Tiqu(message)

for s=1:16
    for b=1:16
        S(:,:,b)=message(:,:,b);
        if bin2dec(num2str(S(33,1:8,b)))== s
            X(:,:,s)= S(:,:,b);
        end
    end
end
S_bin(:,:,:)=X(1:32,:,:);

rimg1=S_bin(:,:,1:4);
rimg2=S_bin(:,:,5:8);
rimg3=S_bin(:,:,9:12);
rimg4=S_bin(:,:,13:16);

for ii=1:4
    Ring1(:,32*(ii-1)+1:32*ii)=rimg1(:,:,ii);
    Ring2(:,32*(ii-1)+1:32*ii)=rimg2(:,:,ii);
    Ring3(:,32*(ii-1)+1:32*ii)=rimg3(:,:,ii);
    Ring4(:,32*(ii-1)+1:32*ii)=rimg4(:,:,ii);
end
reimg=cat(1,Ring1,Ring2,Ring3,Ring4);