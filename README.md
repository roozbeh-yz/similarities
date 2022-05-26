**ANALYZE SIMILARITIES IN IMAGE-CLASSIFICATION DATASETS USING WAVELETS AND SPECTRAL METHODS**


This code implements an algorithm for analyzing similarities in image datasets. The main idea, a formal algorithm, and its results on CIFAR-10 and CIFAR-100 datasets are presented in this paper: https://arxiv.org/pdf/2002.10257.pdf

Below we explain some details of the algorithm.

**Choice of wavelet basis:** 
In the experiments and in the code, we use the 2D Daubechies-1 wavelet basis. Other choices of wavelets are possible and may lead to comparable results. For example, in the case of CIFAR-10 dataset, using Haar wavelets, and other Daubechies wavelets all lead to similar results. Using Daubechies wavelets of higher order will extract more features from images, but those extra features are not necessarily useful. This is reflected in the rank of wavelet coefficient matrix. For example, when we use Daubechies-2 wavelets instead of Daubechies-1, the columns of the wavelet coefficient matrix increases, but the numerical rank of the matrix remains almost the same, and the contents of clusters also do not change. This implies that Daubechies-1 has sufficient power to extract the relevant features from images of this dataset, and results are not sensitive to the choice of wavelet basis. In practice and for other datasets, we recommend that several wavelet basis be used to extract the features and its effect on the numerical rank of wavelet coefficient matrix be investigated. Since this only takes less than a minute for the entire CIFAR dataset, such investigation will not be a computational obstacle.

**Choice of feature selection method:**
Feature selection has a rich literature, and there are many methods that can be used to select the useful features. In this paper, we use the rank-revealing QR factorization which is a well-known algorithm in numerical linear algebra. Rank-revealing QR sorts the features based on their contribution to the rank of matrix and its computational complexity is O(n^3). While computing this factorization, it is possible to stop the process as soon as we reach the first redundant feature, as the rest of the features would be redundant as well.
It is possible to use other feature selection methods. For example, in this paper, we used the Laplacian scores instead of rank-revealing QR factorization:
Using Wavelets and Spectral Methods to Study Patterns in Image-Classification Datasets https://arxiv.org/pdf/2006.09879.pdf
Having redundant features may remove some computational burden from the clustering stage of our algorithm, however discarding such features is not absolutely essential and keeping them might not have an effect on the contents of clusters. We recommend experimenting with feature selection of your choice.

**Deriving the graph Laplacian, and analyzing its eigen-gaps:**
The procedure we follow for deriving the graph Laplacian and analyzing its eigen-gaps is standard and there are numerous books and references available on this topic. In the paper, we have cited a reference on this topic by von Luxburg.

**Clustering method:** 
In this paper and in our code, we have used spectral clustering. As we have explained in the paper, it may sometimes be beneficial to use other clustering algorithms. This is an open choice for all applications that involve clustering. We recommend following the best practices in choosing the clustering method.

**Running time:**
For the CIFAR datasets, it only takes less than a minute to cluster the images of the entire dataset using a Macbook Pro. This is significantly faster than the alternative method of using pre-trained models which may take hours on GPU devices.
