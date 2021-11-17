function [train,test] = loadimagesLab()

for m = 1:40
    Path = ['./orl_faces/Train/s',num2str(m)];
    Data = dir(fullfile(Path,'*.pgm'));
    for n = 1:numel(Data)
        ds{n,m} = imread(fullfile(Path,Data(n).name));
    end
end
dssize = size(ds);
X = [];
for i=1:dssize(2)
    for j=1:dssize(1)
        temp = ds{j,i};
        line = double(reshape(temp,[],1));
        %ds{i,j} = reshape(temp,[],1);
        X = horzcat(X,line);
    end
end
train = X;

clear ds;
clear n;

for m = 1:40
    Path = ['./orl_faces/Test/s',num2str(m)];
    Data = dir(fullfile(Path,'*.pgm'));
    for n = 1:numel(Data)
        ds{n,m} = imread(fullfile(Path,Data(n).name));
    end
end
dssize = size(ds);
Y = [];
for i=1:dssize(2)
    for j=1:dssize(1)
        temp = ds{j,i};
        line = double(reshape(temp,[],1));
        %ds{i,j} = reshape(temp,[],1);
        Y = horzcat(Y,line);
    end
end
test = Y;
end

