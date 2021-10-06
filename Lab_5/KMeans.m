%  K-Means function to generate K clusters of an input image
%  Author Name:
function [C, segmented_image] = KMeans(X,K,maxIter)
%% 1. Image vectorization based on RGB components
X = im2double(X);
[w,l,c] = size(X);
X = reshape(X,[],3);
%% 2. Intial RGB Centroid Calculation
random = rand(K,1)*size(X,1);
random = round(random);
%% 3. Randomly initializing K centroids (select those centroids from the actual points)
centroids = X(random,:);
distance = zeros(size(X,1),K);
cluster_map = zeros(size(X,1),1);
%% 
% 4. Assign data points to K clusters using the following distance - dist = norm(C-X,1)
% 5. Re-computing K centroids
% Reiterate through steps 4 and 5 until maxIter reached. Set maxIter = 100

% Iteration loop
for i = 1:maxIter
    % each pixel
    for pixel = 1:size(X,1)
        %find the dist between each pixel and centeroid
        for cluster_center = 1:K
            dist_tmp = centroids(cluster_center,:) - X(pixel,:);
            distance(pixel, cluster_center) = norm(dist_tmp,1);
        end  
    end
    %update whcih cluster each pixel belong to
    for pixel = 1:size(X,1)
        [value,cluster_map(pixel)] = min(distance(pixel,:));
    end
    %get new cluster center
    for cluster_center = 1:K
        index = find(cluster_map == cluster_center);
        change_pixel = X(index,:);
        new_centroids(cluster_center,:) = mean(change_pixel);
    end
    centroids = new_centroids;
end

%% Return K centroid coordinates and segmented Image
for cluster_center = 1:K
    index = find(cluster_map == cluster_center);
    for j = 1:length(index)
        new_img(index(j),:) = centroids(cluster_center,:);
    end
end
C = centroids;
segmented_image = reshape(new_img,[w,l,c]);
end
