function [Match1, Match2, Match3, Accuracy] = ComputeEigenFaces(Test_Image, Img_Name, P, D, L, TestPath)
%% COMPUTEEIGENFACES recognizes the Correct Matches for the give Test Image.
%   Input
%
%       P    - PCA Projection Matrix
%       D    - Matrix containing each Training Image as 1D vector
%       L    - Matrix with the label of each Image in the Training set
%
%   Output
%       Match 1, 2, 3 - All three Matches
%       Accuracy      - Recognition Accuracy

%% Function starts here

%% Perform PCA on Train and Test Images

% Compute Feature Vectors of all Train Images
Feature_Vector_Train = double(D) * P; % pxN_pca Matrix

% Reshape 2D Test_Image into 1D Image Vector
[row, col] = size(Test_Image);
Img = reshape(Test_Image',1,row*col);
D_Img = double(Img);

% Compute Feature Vector for the Test Image
Feature_Vector_Test = D_Img * P;  % 1xN_pca Matrix

%% Calculate Euclidean Distance between Test Vector and all Train Vectors
Euc_dist = [];
[r,~] = size(Feature_Vector_Train);

for i = 1 : r
    temp = Feature_Vector_Train(i,:);
    Diff = (norm(Feature_Vector_Test - temp))^2;
    Euc_dist = [Euc_dist Diff];
end

% Sort the Euclidean distances in Ascending order
[~,Idx] = sort(Euc_dist);

%% Find Best Matches and Construct Eigen Faces
Error = 0;
Len = size(D,1);

for i = 1:Len
    if strcmp(L(Idx(i),:),Img_Name(1:5))  % If Label Matches
        
        Match1 = reshape(D(Idx(i),:),64,64)'; %output the recognised image
        break;
    else
        Error = Error + 1; % If not Recognised increase Error
    end
end

for j = i+1:Len
    if strcmp(L(Idx(j),:),Img_Name(1:5))  % If Label Matches
        
        Match2 = reshape(D(Idx(j),:),64,64)'; %output the recognised image
        break;
    end
end

for k = j+1:Len
    if strcmp(L(Idx(k),:),Img_Name(1:5))  % If Label Matches
        
        Match3 = reshape(D(Idx(k),:),64,64)'; %output the recognised image
        break;
    end
end

%% Calcualte Accuracy

TestImages = length(TestPath);
Acc = (1-Error/TestImages)*100;
Accuracy = round(Acc,2);

end

