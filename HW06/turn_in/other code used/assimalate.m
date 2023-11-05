%assimilate
%Scott Watkins
close all
location = {'classifying/IMG1/IMG1/IMG1/IMG1/IMG1/',...
    'classifying/IMG2/',...
    'classifying/IMG3/IMG3/',...
    'classifying/IMG4/IMG4/'};
imgcount = [55541 62460 80205 60485];
tot = sum(imgcount);
T = [];
index = 0;
for(i = 1:4)
    Loc = location{i};
    load([Loc,'mapt',num2str(i),'.mat'])
    T = [T,t];
    for(n = 1:imgcount(i))
        index = index + 1;
        if(rem(index,1000)==0)
            fprintf('%f%%\n',100*index/tot)
        end
        imwrite(imread([Loc,num2str(n),'.tiff']),['Images2/',num2str(index),'.tiff'])
    end
end
t = T;
save('Images2/mapt','t')
%check sum
if(index~=numel(t))
    error('failed checksum')
else
    fprintf('Checksum pass: index = %i, T = %i\n',index,numel(t))
end
fprintf('Done\n')