%% This scripts used to show the results for per-pixel BRDF estimation
% We test the per-pixel framework based on the known surface normals

addpath('../include')
%% load synthetic BRDF 
load('../data/syn_brdf/brdf');

%% load lighting directions
fid = fopen('../lighting/lights.txt','rb');
temp = textscan(fid, '%s %f %f %f');
lightMatrix = [temp{2} temp{3} temp{4}];
light = -lightMatrix';

%% load test surface normals
load('../data/surface normals/testNormal.mat');
% relighting the objects for the varying lightings
vog = relight(testNormal, light, brdf, 1);

tSampleR = zeros(length(vog), size(testNormal, 2));
tSampleG = zeros(length(vog), size(testNormal, 2));
tSampleB = zeros(length(vog), size(testNormal, 2));
for i = 1:length(vog)
    temp = vog{i};
    tSampleR(i, :) = reshape(temp(:, 1), 1, []);
    tSampleG(i, :) = reshape(temp(:, 2), 1, []);
    tSampleB(i, :) = reshape(temp(:, 3), 1, []);
end

% load Bmatrix
% you need to have Bmatrix, and change the following command accordingly
file = dir('F:/newCode/B_matrix_updated/Bn5*.mat');
load(['F:/newCode/B_matrix_updated/' file(1).name]);
opt.lambda = .6;
[cR, cG, cB] = brdfEst(tSampleR, tSampleG, tSampleB, ...
                              B_totalR, B_totalG, B_totalB, ...
                              idNormals, opt);

