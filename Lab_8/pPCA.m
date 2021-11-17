function [init_log_likihood,log_likihood_list] = pPCA(K,number,sort_train)
%%
%number =0;
train_image = sort_train{number+1};
[D,N] = size(train_image);%xuan shu zi
train_images_mean = mean(train_image,'all');
train_images_centered = train_image-train_images_mean*ones(D,N);
%% initial
%K = 50;
w = randn(D,K);
sigma = abs(randn(1,1));
I = eye(K) ;
% get log-likelihood
M = w'* w + sigma.*I;

U = chol(M);
V = inv(U);
%T = (inv(chol(U'))*transpose(inv(chol(U'))))*(w'*train_images_centered);
T = inv(U')*(w'*train_images_centered);

%S = sum(train_images_centered.^2,'all');
S = sum(vecnorm(train_images_centered,2,1).^2);

sum_T = sum(abs(T).^2,'all');
TrSM = (S - sum_T)/(N*sigma);
logM = 2*sum(log(diag(U)))+(D - K)*log(sigma); 
init_log_likihood = (-N/2)*(D*log(2*pi) + logM + TrSM);

%% EM
log_likihood_list=[];
% h = waitbar(0,'training');
iteration =10;
for iter = 1:iteration
%     str = ['Training ', num2str(iter/iteration*100),'%'];
%     waitbar(iter/iteration,h,str);
    % E-step
    M = w'*w + sigma*eye(K);
    U = chol(M);
    V = inv(U);
    Minv = V*V';

    for i=1:N
        Ezn{i} = Minv* w' *train_images_centered(:,i);
        Eznznt{i} = sigma.*Minv + Ezn{i}*Ezn{i}';
    end
    % M-step
    P=0;
    Q=0;
    
    for i = 1:N
        P = P + train_images_centered(:,i)*Ezn{i}';
        Q = Q + Eznznt{i};
    end
    w_new = P * inv(Q);
    sum_sigma_new=0;
    for i =1:N
        sum_sigma_new = sum_sigma_new + (norm(train_images_centered(:,i))^2 - 2*Ezn{i}'* w_new'*train_images_centered(:,i)+trace(Eznznt{i}*w_new'*w_new));
    end
    sigma_new=sum_sigma_new/(N*D);
    
    w = w_new;
    sigma = sigma_new;
    % compute log-likelihood
    M = w'* w + sigma.*I;

    U = chol(M);
    V = inv(U);
    %T = (inv(chol(U'))*transpose(inv(chol(U'))))*(w'*train_images_centered);
    T = inv(U')*(w'*train_images_centered);

    %S = sum(train_images_centered.^2,'all');
    S = sum(vecnorm(train_images_centered,2,1).^2);

    sum_T = sum(abs(T).^2,'all');
    TrSM = (S - sum_T)/(N*sigma);
    logM = 2*sum(log(diag(U)))+(D - K)*log(sigma); 
    log_likihood = (-N/2)*(D*log(2*pi) + logM + TrSM);
    log_likihood_list = [log_likihood_list,log_likihood];
end
% delete(h)
% figure()
% plot(log_likihood_list);

%%
figure()
for i = 1:25
    zgen = randn(K,1);
    xgen = w*zgen;
    xgen = xgen+train_images_mean;
    xgen_im = reshape(xgen,28,28);
    subplot(5,5,i)
    imshow(xgen_im)
%     title(num2str(number))
end
saveas(gcf,[num2str(number),'_',num2str(K),'.png']);
end

