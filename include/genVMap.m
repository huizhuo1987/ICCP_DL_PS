% This function generate the vicinity mapping for candiate normals
% in two adjacent sampling scales, and we use it to guide the 
% multi-scale searching
% 

% input
% 1. cNormal: surface normals in coarse samplings
% 2. fNormal: surface normals in finer samplings
% 3. scale: the sampling for the cNormals in degree

% output
% the mapping relation for each normal in coarse sampling
function mapSet = genVMap(cNormal, fNormal, scale)
    mapSet = cell(1, size(cNormal, 2));
    for kk = 1:size(cNormal, 2)
        temp = fNormal'*cNormal(:, kk);
        temp = acos(temp)*180/pi;
        idx = find(temp <= scale);
        mapSet{kk} = idx;
    end
end