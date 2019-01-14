function [P] = PCATransformationMatrix(D, N_pca)
%% PCATRANSFORMATIONMATRIX computes the Projection Matrix 'P' so as to project Image Vector from dimensional space to PCA space.
%
%   Input
%       D     - Matrix containing each Training Image as 1D vector
%       N_pca - No. of Principal Components (Selected by the user)
%
%   Output
%       P     - PCA Projection Matrix

%% Function starts here

[r, ~] = size(D);

I_mean = mean(D); % Mean of all images (1 x d)
Matrix_Mean = repmat(I_mean,r,1);  % Duplicate the mean (vector) in a Matrix form (p x d)
DwM = double(D) - Matrix_Mean; % Remove Mean

%Compute Covrainace Matrix
Sig = (DwM * DwM')./(r-1); 

% Here the Covariance Metrix is computed for DxD' instead of D'xD
% because the No. of Non-zero Eigen Values of the Covariance Matrix is
% limited to 'r' (No. of Images) and we are interested only in 'k' Eigen 
% Vectors(V) corresponding to the 'k' largest Eigen Values

% To Calculate Eigen Vectors (V) and Eigen Values (E)
[V, E] = eig(Sig);

% Make the Diagonal Matrix D as a Single vector in Descending Order
E = diag(E);
[~, Idx] = sort(E,1,'descend');

% Sort the Eigen Vectors corresponding the Eigen Values

PC = [];

for i = 1:r
    PC = [PC V(:,Idx(i))];
end

% Calculate the PCA Transformation Matrix (Projection Matrix)
P = DwM' * PC;

% Limit the PCA Transformation Matrix to the number of Principal
% Componenets (N_pca)
P = P(:,1:N_pca);

end

