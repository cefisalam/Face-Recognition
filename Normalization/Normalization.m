%% Code for normalizing the images to a predefined location given by F_x and F_y in the code.

% ### This file should be kept in the same directory with Images and Feature
% files
% data.

% See also: FINDTRANSFORMATION.m

clc;
clear;

%% FIND TRANSFORMATION

% Read the Coordinates of Feature Points (from .txt file)

Features={}; % Create an empty cell to store feature matrices
F_dir = dir('*.txt');

for i = 1:length(F_dir)
    
    filename = F_dir(i).name;
    fid = fopen(filename,'r'); % Open text file in read-only mode
    F=textscan(fid,'%f %f'); % Read the current text file
    fclose(fid);
    
    Features{i}=F; % Store feature matrices for all images in the directory
    
end

F_start = [Features{1}{1} Features{1}{2}];
F_bar(:,:,2) = F_start;

% Predetermined Locations in 64 x 64 Image
F_x = [13 50 34 16 48]';
F_y = [20 20 34 50 50]';

flag = true;

while flag
    
    % Compute the best transformation for the first image
    [c_1, c_2, F_prime] = FindTransformation(F_bar(:,:,2), F_x, F_y);
    F_bar(:,:,1) = F_prime;
    
    % Compute for all images
    Fi_prime = 0;
    
    for Idx = 1:length(F_dir)
        F_1 = [Features{Idx}{1} Features{Idx}{2}];
        [c_1(:,Idx), c_2(:,Idx), F_prime] = FindTransformation(F_1, F_bar(:,1,1), F_bar(:,2,1));
        Fi_prime = Fi_prime + F_prime;
    end
    
    F_bar(:,:,2) = Fi_prime/length(F_dir); % Average of Transformed Feature Locations
    error = max(max(abs(F_bar(:,:,2)-F_bar(:,:,1))));
    
    if  error <=3 % Check for Convergence
        flag = false;
    end
end

%% APPLY TRANSFORMATION

% Create a directory to store Normalized Images
if ~ exist ('Faces_Normalized', 'dir' )
    mkdir ('Faces_Normalized')
end

Path = './Faces_Normalized/';
I_dir =  [dir(fullfile('*jpg')); dir(fullfile('*JPG')); dir(fullfile('*jpeg'))];

for Idx = 1:length(I_dir)
    
    % Read Images from directory
    file = I_dir(Idx).name;
    Image = rgb2gray(imread(file));
    
    % Apply Transformation to the Images to get 64 x 64 Normalized Image
    temp = [0 0 1]';
    tform = affine2d([c_1(:,Idx) c_2(:,Idx) temp]); % Calculating Affine Transform for each Image

    Rout = imref2d([64 64]);
    Norm_Image{Idx} = imwarp(Image,tform,'OutputView',Rout); % Transformed 64 x 64 Image
    
    % Save Normalized file
    savefilename = strcat(Path,file);
    imwrite(Norm_Image{Idx},savefilename,'jpg');
    
end