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
%%
A=[];
for i = 1 :size(Data,1) 
    A = [A;(Data{i,1})];
end
A = A';
%%
h = waitbar(0,'training');
for i = 1:class_num
    for j = 1:size(Data{i,2},1)
        str = ['Training ', num2str(((i-1)*size(Data{i,2},1)+j)/(class_num*size(Data{i,2},1))*100),'%'];
        waitbar(((i-1)*size(Data{i,2},1)+j)/(class_num*size(Data{i,2},1)),h,str);      
        x = Data{i,2}(j,:);
        new_weights{i}(j,:) = SolveBP(A, x', size(A,2),5,1,1e-3);
        I = 1;
        for c = 1 : class_num
            alpha{c} = new_weights{i}(j,I:I+nl(c)-1);
            I = I+nl(c);
        end
        for c = 1 :class_num
            D = Data{c,1};
            recon_data = alpha{c}*D;
            recon_error{i}(c) = norm(x-recon_data,2);
        end
        [value,index_dev] = min(recon_error{i});
        class_dev{i}(j) = index_dev;
    end
end
delete(h)
h = waitbar(0,'training');
for i = 1:class_num
    for j = 1:size(Data{i,3},1)
        str = ['2 Training ', num2str(((i-1)*size(Data{i,3},1)+j)/(class_num*size(Data{i,3},1))*100),'%'];
        waitbar(((i-1)*size(Data{i,3},1)+j)/(class_num*size(Data{i,3},1)),h,str);
        x = Data{i,3}(j,:);
        new_weights{i}(j,:) = SolveBP(A, x', size(A,2),5,1,1e-3);
        I = 1;
        for c = 1 : class_num
            alpha{c} = new_weights{i}(j,I:I+nl(c)-1);
            I = I+nl(c);
        end
        for c = 1 :class_num
            D = Data{c,1};
            recon_data = alpha{c}*D;
            recon_error{i}(c) = norm(x-recon_data,2);
        end
        [value,index_eval] = min(recon_error{i});
        class_eval{i}(j) = index_dev;
    end
end
delete(h)

dev_acc = Accuracy(class_dev)
eval_acc = Accuracy(class_eval)