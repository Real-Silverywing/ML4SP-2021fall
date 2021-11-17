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
        nl(j,i) = size(Data{j,i},1);
    end    
end
%% Normalizing the length of all I-vectors x
normalized_data = Data;
for i = 1:class_num%24
    for j = 1:size(Data,2)%3
        [r,c] =size(Data{i,j});
        for k = 1 : r
            normalized_data{i,j}(k,:) = Data{i,j}(k,:) ./ norm(Data{i,j}(k,:));
        end
    end
end
%% LDA training
% Estimate the between class covariance
all_Ivectors = [];%all I-vectors
for i = 1 :class_num
    all_Ivectors = [all_Ivectors;normalized_data{i,1}];
end
w_bar = mean(all_Ivectors,1);

for i = 1:class_num
    nl(i,:) = size(Data{i,1},1);
end

Sb = zeros(600,600);
for i = 1 :class_num
    wl(i,:) = mean(normalized_data{i,1},1);
    diff = wl(i,:)-w_bar;
    Sb = Sb + nl(i)*(diff'*diff);
end
% Estimate the within class covariance
Sw = zeros(600,600);
for i = 1 :class_num
    for j = 1:nl(i)
        diff = normalized_data{i,1}(j,:)-mean(normalized_data{i,1},1);
        Sw = Sw + (diff'* diff);
    end
end
% Eigen problem

[V,D] = eigs(Sb,Sw,class_num-1);

%% Classifier training
%Project the i-vectors 
for i = 1 : class_num 
    for j = 1 :size(normalized_data{i,1},1)      
        w = (normalized_data{i,1}(j,:))';
        w_prime{i}(j,:) = V'* w/(norm(V'* w));
    end
end
% For each class l compute the mean and normalized its length
for i = 1 : class_num
    m{i} = mean(w_prime{i})/norm(mean(w_prime{i}));
end
%% Classifier testing
for i = 1 : class_num 
    for j = 1 :size(normalized_data{i,2},1)
        w_dev = (normalized_data{i,2}(j,:))';
        w_dev_prime{i}(j,:) = V'* w_dev/(norm(V'* w_dev));
    end
end

for i = 1 : class_num 
    for j = 1 :size(normalized_data{i,3},1)
        w_eval = (normalized_data{i,3}(j,:))';
        w_eval_prime{i}(j,:) = V'* w_eval/(norm(V'* w_eval));
    end
end

for i = 1 : class_num 
    for j = 1:length(w_dev_prime{1})
        for k = 1:length(m)
            score_dev{i}(j,k) = dot(m{k},w_dev_prime{i}(j,:));
            score_eval{i}(j,k) = dot(m{k},w_eval_prime{i}(j,:));
        end
        [value,index_dev] = max(score_dev{i}(j,:));
        [value,index_eval] = max(score_eval{i}(j,:));
        class_dev{i}(j) = index_dev;
        class_eval{i}(j) = index_eval;
    end
end
dev_acc = Accuracy(class_dev)
eval_acc = Accuracy(class_eval)