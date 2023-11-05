%image clasiffier
%Scott Watkins

close all 
clear all
pixelSizeCutoff = 150;
index = 0;
for File = 76:113
[boxes, Img] = DetectionHelperFunc(File);
n = size(boxes);
N = n(1);
imshow(Img)
fprintf('Preview\n')
input('Press Enter')
rflag = false;
blankflag = false;
i = 0;
while i < N
    if rflag
        rflag =false;
        disp 'rflag'
    elseif blankflag 
        blankflag =false;
        disp 'blankflag'
    else
        i = i+1;
    index = index+1;
    disp 'normal'
    end
    image = Img(ceil(boxes(i,2)):(ceil(boxes(i,2))+boxes(i,4)-1),ceil(boxes(i,1)):(ceil(boxes(i,1))+boxes(i,3)-1));
    imwrite(image,['Images/',num2str(index,'%i'),'.tiff'])
    if(boxes(i,3)*boxes(i,4)>pixelSizeCutoff)
        imshow(image,'InitialMagnification',800);
        fprintf('i: %i, index: %i, File %i\n',i,index,File)
        raw = [];
        raw = input('Number of worms: ','s');
        num = str2double(raw);
        if(isnan(num))
        if(raw == 'r')
            i = lasti;
            index = lastindex;
            rflag = true;
            disp 'r check'
            continue;
        else
            blankflag = true;
            disp 'blank check'
            continue;
        end
        else
        t(index) = num;
        %fprintf('Number of worms: %i\n',num)
        lasti = i;
        lastindex = index;
        %make sure the last one is correct
        if i == N
            surecheck = input('Are you sure? [y/n]: ','s');
            if surecheck ~= 'y'
                i = i-1;
                continue
            end
        end
        end
    else
        disp 'Too small'
        t(index) = 0;
    end
end
end
save('mapt3.mat','t')
function [bboxes, I1]= DetectionHelperFunc(File)
I1=imread(['WormData/00',num2str(File,'%i'),'.jpg']);
I1=rgb2gray(I1);
%figure; imshow(I1,[])

[M,N]=size(I1);
[U,V]=meshgrid([1:N],[1:M]);
D= sqrt((U-(N+1)/2).^2+(V-(M+1)/2).^2);
D0=2;
n=2; 
one=ones(M,N);
H = 1./(one+(D./D0).^(2*n));
G=fftshift(fft2(I1)).*H;
g=real(ifft2(ifftshift(G)));
out=double(I1)-g;
I1=uint8((255.0/(max(out(:))-min(out(:)))).*(out-min(out(:))));

th=imbinarize(I1,'Adaptive','Sensitivity',0.4);
%figure; imshow(I1,[])
%figure; imshow(th,[])
%figure; imshow(imoverlay(I1,th,'r'),[])

[outL,outN]=bwlabel(th);

fstats=regionprops('table',outL,'Area','BoundingBox');
bboxes=fstats.BoundingBox;

%Things = insertShape(I1,'Rectangle',bboxes,'LineWidth',3);
%figure; imshow(Things,[]);

end