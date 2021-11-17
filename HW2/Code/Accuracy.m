function [acc] = Accuracy(class)

x = [];
key = [];
for i = 1:length(class)
    x = [x,class{i}];
    key = [key,repmat(i,1,length(class{i}))];
end
correct = length(find(x==key));
total = numel(x);

acc = correct/total;
end