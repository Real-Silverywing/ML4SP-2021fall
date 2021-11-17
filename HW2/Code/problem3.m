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
for i = 1:class_num
    for j = 1:size(Data,2)
        [r,c] =size(Data{i,j});
        for k = 1 : r
            norm1 = norm(Data{i,j}(k,:));
            normalized_data{i,j}(k,:) = Data{i,j}(k,:) ./ norm1;
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
    vector_size = size(normalized_data{i,1},1);
    for j = 1 :vector_size      
        w = (normalized_data{i,1}(j,:))';
        w_prime{i}(j,:) = V'* w/(norm(V'* w));
    end
end

%% Classifier testing
for i = 1 : class_num 
    vector_size = size(normalized_data{i,2},1);
    for j = 1 :vector_size
        w_dev = (normalized_data{i,2}(j,:))';
        w_dev_prime{i}(j,:) = V'* w_dev/(norm(V'* w_dev));
    end
end

for i = 1 : class_num 
    vector_size = size(normalized_data{i,3},1);
    for j = 1 :vector_size
        w_eval = (normalized_data{i,3}(j,:))';
        w_eval_prime{i}(j,:) = V'* w_eval/(norm(V'* w_eval));
    end
end
%%
A=[];
for i = 1 :size(Data,1) 
    A = [A;(Data{i,1})];
end
A = A';
%%

h = waitbar(0,'training');
for i = 1 : class_num 

    for j = 1 :length(w_dev_prime{i})
        str = ['Training ', num2str(((i-1)*length(w_dev_prime{i})+j)/(class_num*length(w_dev_prime{i}))*100),'%'];
        waitbar(((i-1)*length(w_dev_prime{i})+j)/(class_num*length(w_dev_prime{i})),h,str);
        x = w_dev_prime{i}(j,:);
        new_weights{i}(j,:) = SolveBP(V'*A/norm(V'*A), x',size(A,2),5,1,1e-3);
        I = 1;
        for r = 1 : class_num
            alpha{r} = new_weights{i}(j,I:I+nl(r)-1);
            I = I+nl(r);
        end
        for r = 1 :class_num
            D = (V'*Data{r,1}'/norm(V'*Data{r,1}'))';
            recon_data=alpha{r}*D;
            recon_error{i}(r) = norm(x - recon_data,2);
        end
        [value,index_dev] = min(recon_error{i});
        class_dev{i}(j) = index_dev;
    end
end
delete(h)

for i = 1 : class_num 
    for j = 1 :length(w_eval_prime{i})
        x = w_eval_prime{i}(j,:);
        projA = V'*A/norm(V'*A);
        new_weights{i}(j,:) = SolveBP(V'*A/norm(V'*A), x',size(A,2),5,1,1e-3);
        I = 1;
        for r = 1 : class_num
            alpha{r} = new_weights{i}(j,I:I+nl(r)-1);
            I = I+nl(r);
        end
        for r = 1 :class_num
            D = (V'*Data{r,1}'/norm(V'*Data{r,1}'))';
            recon_data=alpha{r}*D;
            recon_error{i}(r) = norm(x - recon_data,2);
        end
        [value,index_eval] = min(recon_error{i});
        class_eval{i}(j) = index_eval;
    end
end
dev_acc = Accuracy(class_dev)
eval_acc = Accuracy(class_eval)
result = [dev_acc;eval_acc]