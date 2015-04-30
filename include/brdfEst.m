%% This function implments the per-pixel BRDF estimation as proposed in 

% A Dictionary-based Approach for Estimating Shape and 
% Spatially-Varying Reflectance
% Zhuo Hui and Aswin Sankaranarayanan
% ICCP 2015

%% Input
% tSampleR,(G,B): The observed intensities of the objects under varying
%                 lightings in R, G, B channels

% B_totalR,(G, B): The Bmatrix in the finest sampling level
%                  R, G, B denotes the color channel

% idNormals: the index of the estimated surface normals in the B matrix 

% opt: lambda = the tune parameter for the sparsity constraints
%      you can add more constraints to set up the inner non-negative lasso
%% Output
% cR,G,B: The estimated coefficents per-pixel in R, G, B channels

function [cR, cG, cB] = brdfEst(tSampleR, tSampleG, tSampleB, ...
                              B_totalR, B_totalG, B_totalB, ...
                              idNormals, opt)
    cR = zeros(size(B_totalR, 2), size(tSampleR, 2));
    cG = cR;
    cB = cR;
    lambda = opt.lambda;
    
    for i = 1:size(tSampleR, 2)
        yR = tSampleR(:, i);
        yG = tSampleG(:, i);
        yB = tSampleB(:, i);
        
        % thresholding the pixels 
        y_new = .299 * yR + .587 * yG + .114 * yB;
        idd = find((y_new > 0) & (y_new < .95)); %.9
        
        BnR = B_totalR(idd, :, idNormals(i)); 
        BnG = B_totalG(idd, :, idNormals(i)); 
        BnB = B_totalB(idd, :, idNormals(i)); 


        cR(:, i) = brdf_solver_cvx(yR(idd), BnR, lambda);
        cG(:, i) = brdf_solver_cvx(yG(idd), BnG, lambda);
        cB(:, i) = brdf_solver_cvx(yB(idd), BnB, lambda);
    end
end