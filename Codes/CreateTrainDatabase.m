function [D, L] = CreateTrainDatabase(Path)
%% CREATETRAINDATABASE creates a Matrix to store Train Images.
%
%   Input
%       Path - Path to the directory containing Images
%
%   Output
%       D    - Matrix containing each Training Image as 1D vector
%       L    - Matrix with the label of each Image in the Training set

%% Function starts here

Image_dir = [dir(fullfile(Path,'*jpg')); dir(fullfile(Path,'*JPG')); dir(fullfile(Path,'*jpeg'))];

D = []; % Data Matrix
L = []; % Label Matrix

for Idx = 1:length(Image_dir)
    
    % Read the Images from directory
    Img_name = Image_dir(Idx).name;
    filename = strcat(Path,Img_name);
    Image = imread(filename);
    [r, c] = size(Image);
    
    temp = reshape(Image',1,r*c);   % Reshaping 2D Images into 1D Image Vectors
    D = [D; temp];
    L = [L; Img_name(1:5)];
    
end

end