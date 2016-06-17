%% The function load the data from test benche database
% Input:
% scale: the downsampling factor. w.o. downsampling, use 1 here
% base_dir: the path to the input images
% object: the object name would like to test

% Output:
% 1. tSampleR/G/B: one each is a M by Q matrix, where M is the number of
% pixels with mask value being not 0, and Q is the number of light sources

% 2. mask: the mask of the object
% 3. lightMatrix: the lighting directions

function  [tSampleR, tSampleG, tSampleB, mask, lightMatrix]= processPsData(scale, base_dir, object)

fid = fopen([base_dir sprintf('%s/light_directions.txt', object)], 'rb');    
temp =  textscan(fid,'%f %f %f');%[directory, '/',  imagename, '/lights.txt']; %lights
lightMatrix = [temp{1} temp{2} temp{3}];
lightMatrix = lightMatrix';

fid = fopen([base_dir sprintf('%s/light_intensities.txt', object)], 'rb');    
temp =  textscan(fid,'%f %f %f');%[directory, '/',  imagename, '/lights.txt']; %lights
lightInt = [temp{1} temp{2} temp{3}];
lightInt= lightInt';

numLights = size(lightMatrix, 2);
mask = imread([base_dir sprintf('%s/mask.png', object)]);
%mask = imread(sprintf('f:/newCode/%s/mask.png', object));

if size(mask, 3) > 1
    sizImg = size(mask);
    mask = rgb2gray(mask);    
else
    sizImg = [size(mask) 3];
end

mask = mask(1:scale:end, 1:scale:end);

ind = find(mask > 0);

fl = dir([base_dir sprintf('%s/0*.png', object)]); %

tSampleR = zeros(numLights, length(ind));
tSampleG = zeros(numLights, length(ind));
tSampleB = zeros(numLights, length(ind));
for i = 1:length(fl)
    img = imread([base_dir sprintf('%s/', object) fl(i).name]);
    img = im2double(img);
    img = img(1:scale:end, 1:scale:end, :);
    
    
    img(:,:,1) = img(:, :, 1)./lightInt(1, i);
    img(:,:,2) = img(:, :, 2)./lightInt(2, i);
    img(:,:,3) = img(:, :, 3)./lightInt(3, i);
    
    imgR = reshape(img(:,:,1), 1, []);
    imgG = reshape(img(:,:,2), 1, []);
    imgB = reshape(img(:,:,3), 1, []);
    tSampleR(i, :) = imgR(ind);
    tSampleG(i, :) = imgG(ind);
    tSampleB(i, :) = imgB(ind);
end