%% 
% This scripts used to demo our algorithm on the bechmark PS database in
% the following paper
% A Benchmark Dataset and Evaluation for
% Non-Lambertian and Uncalibrated Photometric Stereo
% 
% We test the coarse-to-fine search strategy

%% 1.  load the lighting directions
fid = fopen('lighting/light_pot1.txt','rb');
temp = textscan(fid, '%f %f %f');
lightMatrix = [temp{1} temp{2} temp{3}];
light = lightMatrix';

%% 2. generate B matrix in different scale
files  = 'e:/psmImages/matlabCode/BRDF_data/'; %path to raw BRDF files
% 
save_path = 'F:/newCode/B_matrix/benchMark/bear/';
load('data/candidate normals/canNormal.mat');
deg = {'10', '5', '3', '1', '0_5'};
for kk = 1:length(canNormal)
    normlas = canNormal{kk};
    [B_totalR, B_totalG, B_totalB] = genBmatrix(normals, light, files, 1);
    save([save_path sprintf('Bn%d_%s.mat', kk, deg{kk})], 'normals', 'B_totalR', 'B_totalG', 'B_totalB');
end
%% 3. load B matrix and candidate normals
[Bn, canNormal, mapSet] = initialize(save_path);
normals = canNormal{5};
%% 4. load data from PS testbench mark database
base_dir = 'F:/PS_benchmark/pmsData/'; % path to the input data;
[tSampleR, tSampleG, tSampleB, mask, lM]= processPsData(1, base_dir, 'bearPNG');

%% 5. run our algorithm
opt.lid = 1:96; % lighting distributions
opt.start = 2; % start scale for multi-sclae;
opt.mapSet = mapSet; 
%
opt.thres = 3/255; % the threshold to reject shadows
                % we use 1/255 or 3/255 for testBenchmark database
                % you may need to change the value for optimal performance
% candiate normal ids
[idMat, ~] = ms_normalEst(Bn, tSampleR, tSampleG, tSampleB, opt);

% genertate est surface normals
if size(mask, 3) > 1
    mask = rgb2gray(mask);
end
mask = mask > 0;

Normal_Est = zeros([size(mask), 3]);
Normal_Est = reshape(Normal_Est, [], 3);
Normal_Est(mask > 0, :) = normals(:, idMat(5, :))';
Normal_Est = reshape(Normal_Est, [size(mask) 3]);