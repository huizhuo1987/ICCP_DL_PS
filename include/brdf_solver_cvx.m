%% This function implements the per-pixel brdf solver for the paper
% A Dictionary-based Approach for Estimating Shape and 
% Spatially-Varying Reflectance
% Zhuo Hui and Aswin Sankaranarayanan

% We use cvx package, pl make sure you have set up the cvx before use it
% 
%% Input
% y: the intensities of the pixel under varying lightings

% Bn: the Bmatrix 

% lambda: the parametr to weight the sparsity of the coefficients
%         you need to tune this for your data.

%% Outptu
% c_cvx: the per-pixel relative coefficients


function  c_cvx = brdf_solver_cvx(y, Bn, lambda)
oneT = ones(size(Bn, 2), 1);
K = size(Bn, 2);

cvx_begin
    variable c_cvx(K)
        minimize (norm(y - Bn*c_cvx, 2)  + lambda*norm(c_cvx, 1));
        subject to
            c_cvx >= 0
cvx_end

end