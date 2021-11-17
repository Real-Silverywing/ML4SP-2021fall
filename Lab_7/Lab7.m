% You can create a function on the form: 
clc
clear
[traindata,testdata]=loadimagesLab();
%%
%You can create several functions on the form:
% [TrainingPCA,TestingPCA]=PCAlab(trainingdata,testingdata,PCAdimension);
% [V,D,TrainingLDA,TestingLDA]=LDAlab(TrainingPCA,TestingPCA,LDAdimension);
dimension = 200;
[trainProj,testProj] = PCA(dimension,traindata,testdata);
%%
% LDA
Sb = zeros(dimension,dimension);
m = mean(trainProj,2);
for i=1:40
    idx = 9*(i-1);
    mk(:,i) = mean(trainProj(:,idx+1:idx+9),2);
    idx=9.*(mk(:,i)-m)*(mk(:,i)-m)';
    Sb=Sb+idx;
end
Sw = zeros(dimension,dimension);
Nk = zeros(dimension,dimension);
for i = 1:40
    idx = 9*(i-1);
    mk(:,i) = mean(trainProj(:,idx+1:idx+9),2);
    for n = 1:9
        Nk=Nk+(trainProj(:,idx+n)-mk(:,i))*(trainProj(:,idx+n)-mk(:,i))';  
    end
    Sw = Sw + Nk;
end
[V,D]=eigs(Sb, Sw, 40-1);
%%
label = 1:40;
accuracy_LDA=[];
d = [10,20,30,39];
dist = [];
for i = 1:4
    LDA_trainproj=V(:,1:d(i))'*trainProj;
    LDA_testproj=V(:,1:d(i))'*testProj;
    for m = 1:size(LDA_testproj,2)
        for n = 1:size(LDA_trainproj,2)
            dist(n,m)=norm(LDA_testproj(:,m)-LDA_trainproj(:,n));
        end
    end
    [dist,index] = sort(dist,'ascend');
    key = index(1,:);
    key = ceil(key/9);
    accuracy_LDA(1,i) = length(find(key==label))/size(key,2);
end
%%
% 
LDA_d = 39;
LDA_trainproj=V(:,1:LDA_d)'*trainProj;
LDA_testproj=V(:,1:LDA_d)'*testProj;
train_labels = repmat(label',1,9);
train_labels = reshape(train_labels',1,[]);
t = templateSVM('KernelFunction','linear','BoxConstrain',0.01);
SVMModel = fitcecoc(LDA_trainproj,train_labels,'Learners',t,'ObservationsIn','columns');
svm_predict = predict(SVMModel,LDA_testproj');
accuracy_svm=length(find(svm_predict==label'))/size(label,2);