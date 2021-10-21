function [train_proj,test_proj] = PCA(base_num,train_images,test_images)

[D1,N1] = size(train_images);
train_images_mean = sum(train_images,2)/N1;
train_images_centered = train_images-train_images_mean*ones(1,N1);

[D,N2] = size(test_images);
test_images_mean = sum(test_images,2)/N2;
test_images_centered = test_images-test_images_mean*ones(1,N2);

corr = train_images_centered * train_images_centered';
[eigvector,eigval] = eig(corr);
eigval_list = diag(eigval);
[eigval_list,index] = sort(eigval_list,'descend');

bases = eigvector(:,index(base_num):index(1));
train_proj = bases' * train_images_centered;
test_proj = bases' * test_images_centered;
end

