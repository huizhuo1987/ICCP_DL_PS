%% The function is to generate the B matrix as shown in the paper
% also needs to use relight function

% Input
% 1. normals: candidate surface normals, dimension 3 * N
% 2. L, Lighting directions: , dimension 3 * Q
% 3. shading: 1 needs to add shading term, 0 not
% 4. directory spcify the folder stores the stores the BRDFs
% 5. shading (1 or 0): 1 adds shading term to B, 0, not

% Output
% Bmatrix for each color channel:
% Dimension of Bmatrix Q*M*N, 
% N: number of candidate normals
% Q: number of lightings
% M: number of materials 

function [B_totalR, B_totalG, B_totalB] = genBmatrix(normals, light, directory, shading)
    files = dir([directory '*.txt']);
    % initialize the B matrix
    B_totalR = zeros(size(light, 2), length(files), size(normals, 2));
    B_totalG = zeros(size(light, 2), length(files), size(normals, 2));
    B_totalB = zeros(size(light, 2), length(files), size(normals, 2));

    % for each candidate normal and all the material in database
    % creat an entry for B matrix. 
    for jj = 1:length(files)
        brdf = textread([directory files(jj).name]);
        vog = relight(normals, light, brdf, shading);
        for j = 1:length(vog)
            temp = vog{j};
            B_totalR(j, jj, :) = reshape(temp(:, 1), [1, 1, size(normals, 2)]);
            B_totalG(j, jj, :) = reshape(temp(:, 2), [1, 1, size(normals, 2)]);
            B_totalB(j, jj, :) = reshape(temp(:, 3), [1, 1, size(normals, 2)]);
        end
    end

end
