clc
clear
%% load data
Data = cell(24,3); 
folder = {'..\Data\Train\','..\Data\Dev\','..\Data\Eval\'};
for i = 1:3
    namelist = dir([folder{i},'*.txt']);
    class_num = length(namelist);
    for j=1:class_num
        Data{j,i}= load(fullfile(namelist(j).folder,namelist(j).name));
    end    
end
%%
for c = 1:3
    class = Data(:,c);
    key=[];
    for i = 1:length(class)
        key = [key;repmat(i,size(class{i},1),1)];
        class_count(i) = size(class{i},1);
    end
    label{c} = key;
    data{c} = cell2mat(Data(:,c));
end

%%
for i = 1:24
    class_data = data{1}(find(label{1} == i),:);
    class_mean(i,:) = mean(class_data,1);
    class_cov{i} = cov(class_data); 
end
%%
total = sum(class_count);
share_cov = 0;
for i = 1:24
    share_cov = share_cov+ (class_count(i)/total)*class_cov{i};
end
%%
for t = 2:3
    count = 0;
    for index = 1:size(data{2},1)
        score = [];   
        for i = 1:24
            M = (data{t}(index,:)-class_mean(i,:))';
            score(i) = log(1/24)+(-1/2*M'*inv(share_cov)*M);
        end
        [~, I] = max(score);
        if((I) == label{t}(index))
          count = count + 1;
        end
    end
    acc(t-1) = count/2400;
end
result = [acc(1);acc(2)]