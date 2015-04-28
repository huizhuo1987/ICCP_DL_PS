%% This function aims to generate relighting results

% Input: 
% object_normal: the surface normals, 3 * N
% light: lighting direction, 3 * Q
% brdf: vectorized BRDF
% shading: 1: needs to add shading term, 0: not

% Output:
% rendering results for different lightings

function vog = relight(object_normal, light, brdf, shading)
% Shading indicates whether to include shading term or not. 
vog = cell(1,size(light,2));
v = [0; 0; 1];
for jj = 1:size(light,2)
    l = light(:,jj);
    relight_obj = zeros(size(object_normal,2), 3);
    for i = 1:size(object_normal,2)
        n = object_normal(:,i);
        
         if n'*v <= 0
            intensity = [0 0 0];
         else
            intensity = brdfMapping(l, v, n, brdf);%
            %intensity = intensity*max(0, n'*l);
         end
         if (shading == 1)
            relight_obj(i, :) = intensity*max(0, n'*l);
         else
            relight_obj(i, :) = intensity;
         end
    end
    vog{jj} = relight_obj;
    fprintf('Done for light direction: %d....\n', jj);
end