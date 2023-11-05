%code creates training set and test set
%scott Watkins

close all
clear all

%% sort data by number of worms
rngset = 2;
rng(rngset)
folder = 'Images2/';
load([folder,'mapt.mat'])  %t

zeroind = 0;
oneind = 0;
twoind = 0;
threeind = 0;
fourind = 0;

for i = 1:numel(t)
    if t(i) == 0
        zeroind = zeroind +1;
        t0(zeroind) = i;
    elseif t(i) == 1
        oneind = oneind +1;
        t1(oneind) = i;
    elseif t(i) == 2
        twoind = twoind +1;
        t2(twoind) = i;
    elseif t(i) == 3
        threeind = threeind +1;
        t3(threeind) = i;
    elseif t(i) == 4
        fourind = fourind +1;
        t4(fourind) = i;
    else
        warning('outside expected number of worms\n')
    end
end

maxsz = 150;
minsz = 3500;

try
    load(['sorting/',num2str(minsz),'_',num2str(maxsz),'.mat'])
catch
    %eliminate those outside this range
    fprintf('sorting: 0\n')
    n = 0;
    t00 = zeros(1,numel(t0));
    for i =1:numel(t0)
    %     img = imread([folder,num2str(t0(i)),'.tiff']);
    %     [a,b] = size(img);
        a = imfinfo([folder,num2str(t0(i)),'.tiff']).Height;
        b = imfinfo([folder,num2str(t0(i)),'.tiff']).Width;
        if (a*b)>minsz&&max(a,b)<=maxsz
            n = n+1;
            t00(n) = t0(i);
        end
        if(rem(i,1000)==0)
        fprintf('%i | %i\n',n,i)
        end
    end
    
    t00 = t00(:,1:n);

    fprintf('sorting: 1\n')
    n = 0;
    t11 = zeros(1,numel(t1));
    for i =1:numel(t1)
    %     img = imread([folder,num2str(t1(i)),'.tiff']);
    %     [a,b] = size(img);
        a = imfinfo([folder,num2str(t1(i)),'.tiff']).Height;
        b = imfinfo([folder,num2str(t1(i)),'.tiff']).Width;
        if (a*b)>minsz&&max(a,b)<=maxsz
            n = n+1;
            t11(n) = t1(i);
        end
    end
    t11 = t11(:,1:n);

    fprintf('sorting: 2\n')
    n = 0;
    t22 = zeros(1,numel(t2));
    for i =1:numel(t2)
    %     img = imread([folder,num2str(t2(i)),'.tiff']);
    %     [a,b] = size(img);
        a = imfinfo([folder,num2str(t2(i)),'.tiff']).Height;
        b = imfinfo([folder,num2str(t2(i)),'.tiff']).Width;
        if (a*b)>minsz&&max(a,b)<=maxsz
            n = n+1;
            t22(n) = t2(i);
        end
    end
    t22 = t22(:,1:n);

    fprintf('sorting: 3\n')
    n = 0;
    t33 = zeros(1,numel(t3));
    for i =1:numel(t3)
    %     img = imread([folder,num2str(t3(i)),'.tiff']);
    %     [a,b] = size(img);
        a = imfinfo([folder,num2str(t3(i)),'.tiff']).Height;
        b = imfinfo([folder,num2str(t3(i)),'.tiff']).Width;
        if (a*b)>minsz&&max(a,b)<=maxsz
            n = n+1;
            t33(n) = t3(i);
        end
    end
    t33 = t33(:,1:n);

    fprintf('sorting: 4\n')
    n = 0;
    t44 = zeros(1,numel(t4));
    for i =1:numel(t4)
    %     img = imread([folder,num2str(t4(i)),'.tiff']);
    %     [a,b] = size(img);
        a = imfinfo([folder,num2str(t4(i)),'.tiff']).Height;
        b = imfinfo([folder,num2str(t4(i)),'.tiff']).Width;
        if (a*b)>minsz&&max(a,b)<=maxsz
            n = n+1;
            t44(n) = t4(i);
        end
    end
    t44 = t44(:,1:n);
    
    save(['sorting/',num2str(minsz),'_',num2str(maxsz),'.mat'],'t00','t11','t22','t33','t44')
end

%scramble data
fprintf('scramble data\n')

t000 = t00(randperm(numel(t00)));
t111 = t11(randperm(numel(t11)));
t222 = t22(randperm(numel(t22)));
t333 = t33(randperm(numel(t33)));

%%

fprintf('creating set\n')
%Set 1, t 0-1
mkdir(['sets/set01v',num2str(rngset),'/','0'])
mkdir(['sets/set01v',num2str(rngset),'/','1'])

n0 = 0;
n1 = 0;
stoppoint = floor(min(numel(t000),numel(t111)));

for i = 1:stoppoint
    msg = sprintf('Progress: %i%%',floor(100*i/stoppoint));
    disp(msg)
    n0 = n0+1;
    imgtemp = imread([folder,num2str(t000(i)),'.tiff']);
    imgtemp = padimage(imgtemp,maxsz,maxsz);
    imgtemp2 = imrotate(imgtemp,90);
    imgtemp3 = imrotate(imgtemp,180);
    imgtemp4 = imrotate(imgtemp,270);
    imwrite(imgtemp,['sets/set01v',num2str(rngset),'/0/',num2str(n0),'.tiff']);
    n0 = n0+1;
    imwrite(imgtemp2,['sets/set01v',num2str(rngset),'/0/',num2str(n0),'.tiff']);
    n0 = n0+1;
    imwrite(imgtemp3,['sets/set01v',num2str(rngset),'/0/',num2str(n0),'.tiff']);
    n0 = n0+1;
    imwrite(imgtemp4,['sets/set01v',num2str(rngset),'/0/',num2str(n0),'.tiff']);
    
    n1 = n1+1;
    imgtemp = imread([folder,num2str(t111(i)),'.tiff']);
    imgtemp = padimage(imgtemp,maxsz,maxsz);
    imgtemp2 = imrotate(imgtemp,90);
    imgtemp3 = imrotate(imgtemp,180);
    imgtemp4 = imrotate(imgtemp,270);
    imwrite(imgtemp,['sets/set01v',num2str(rngset),'/1/',num2str(n1),'.tiff']);
    n1 = n1+1;
    imwrite(imgtemp,['sets/set01v',num2str(rngset),'/1/',num2str(n1),'.tiff']);
    n1 = n1+1;
    imwrite(imgtemp,['sets/set01v',num2str(rngset),'/1/',num2str(n1),'.tiff']);
    n1 = n1+1;
    imwrite(imgtemp,['sets/set01v',num2str(rngset),'/1/',num2str(n1),'.tiff']);
    
    fprintf(repmat('\b',1,numel(msg)+1))
end

fprintf('\nDone\n')

function img = padimage(img,sza,szb)
    [a,b] = size(img);
    a = (sza-a)/2;
    b = (szb-b)/2;
    temp = padarray(img,[floor(a) floor(b)],0,'pre');
    img = padarray(temp,[ceil(a) ceil(b)],0,'post');
end