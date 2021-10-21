function [predicted_labels,accuracy] = myKNN(k,data,labels,t_data,t_labels)
%Input:
%       - k: number of nearest neighbors
%       - data: training data
%       - labels: training labels 
%       - t_data: testing data
%       - t_labels: testing labels 
%Output:
%       - predicted_labels: the predicted labels based on the k-NN
%       algorithm
%       - accuracy: the accuracy of the classification

%initialization
predicted_labels = zeros(1,size(t_data,2));
ed = zeros(size(t_data,2),size(data,2)); 
k_nn = zeros(size(t_data,2),k); 
knn_label = zeros(size(t_data,2),k);

%h=waitbar(0,'please wait');
for test_point=1:size(t_data,2)
    %str=['Running...',num2str(test_point/size(t_data,2)*100),'%'];
    %waitbar(test_point/size(t_data,2),h,str)  
    dist_tmp = data - t_data(:,test_point);
    ed(test_point,:) = sqrt(sum(dist_tmp.^2,1));
end
delete(h);
[ed_sort,ind]=sort(ed,2);
%find the nearest k for each data point of the testing data
k_nn=ind(:,1:k);
%get the majority vote
knn_label =labels(k_nn) ;
predicted_labels = mode(knn_label,2);


%calculate the classification accuracy
accuracy=length(find(predicted_labels==t_labels))/size(t_data,2);

end

