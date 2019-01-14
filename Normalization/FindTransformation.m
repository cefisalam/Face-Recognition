function [c_1, c_2, F_prime] = FindTransformation(F_bar, F_px, F_py)
%% FINDTRANSFORMATION finds the best transformation, (A, b) that maps the feature in F_bar to those in F_p.
%
%   Input
%       F_bar    - Feature of an Image [(x,y) coordinates]
%       F_px     - Predetermined Sample Feature [x coordinate]
%       F_py     - Predetermined Sample Feature [y coordinate]
%
%   Output
%       c_1, c_2 - Parameters of Affine Transformation
%       F_prime  - New Average Location of Features in 64 x 64 image

%% Function starts here

F_1 = [F_bar ones(5,1)];

c_1 = pinv(F_1)*F_px;  % To Calculate Parameters of Affine Transform (given by (A,b))
c_2 = pinv(F_1)*F_py;

F_prime = F_1 * [c_1 c_2]; 

end

