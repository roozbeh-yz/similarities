%% Code for feature extraction from images using wavelets and clustering 
%% the images based on their similarities in the feature space

%% save the data
Data.X; % contains images
% the ith image in Data.X can be pulled by Data.X{i}
% We assume all images have the same size. 
% Images can be 2D like for MNIST, each image has 28x28 pixel values
% or images can be 3D, for CIFAR-10, images are RGB, and have 32x32x3 pixel values
Data.Y; % contains image labels
%% loop over images and decompose them with wavelets
n = numel(Data.X);

wname = 'db1'; % choose a wavelet basis - db1 is Daubechies-1
N = 1; % choose a level numbe

[c,s] = wavedec2(Data.X{1},N,wname); % decompose the first image, 
% just to see how many wavelet coefficients you will get
nf = numel(c); %
Data.W = zeros(n,nf); % intitialize the matrix of wavelet coefficients - 
% rows correspond to images, columns correspond to wavelet coefficients

for i = 1:n
    [c,s] = wavedec2(Data.X{i},N,wname);
    Data.W(i,:) = c;
end

%% Feature selection, i.e., select a subset of wavelet coefficients that are most influential among images
%% option 1- use pivoted QR algorithm to sort the wavelet features based on their linear independence
[~,~,p_qr] = qr(Data.W,'vector');
% p_qr sorts the columns of Data.W. The most important feature is the first
% id in p_qr. The least important one is the last feature in p_qr
% Discard the least influential features from Data.W until the condition number of
% reduced Data.Wr is something close to 10^5 or so. You can experiment with
% different values for condition number and see if it makes a difference in
% your clustering result

% Let's say you decide to pick the 500 most influential wavelet coefficients of images
Data.Wr = Data.W(:,p_qr(1:500));

%% option 2 - use Laplacian Scores to select the most influential wavelet coefficients
idx = fsulaplacian(Data.W);
% Again, idx sorts the columns of Data.W based on their importance
% Let's say for MNIST, you decide to pick the 500 most influential wavelet
% coefficients:
Data.Wr = Data.W(:,idx(1:500));

%% Cluster the images using your desired method of clustering
% Possibly use a method to estimate the number of clusters in the data, then
% proceed with clustering.
% There are so many methods for clustering and estimating the number of clusters. 
% e.g., see this guideline and example: https://www.mathworks.com/help/stats/partition-data-using-spectral-clustering.html


% Note for datasets like CIFAR and MNIST, the number of clusters is quite
% large. It could be 40,000 or so for CIFAR-10. You can see the number of
% clusters I have chosen in my paper based on the eigen-gaps.

% You would typically expect 1,2, or 5 images to appear to each cluster.
% Images in each cluster should be similar to each other.


% You can consider clustering each class of images separately, or you can
% cluster all images together.

% Let's say you decide to cluster all the images in Data.Wr into 40,000
% clusters, using spectral clustering:

k = 40000; % number of clusters - consider experimenting with different 
% number of clusters, based on what you see in the spectrum of the Data.Wr
[id_cluster] = spectralcluster(Data.Wr,k);

