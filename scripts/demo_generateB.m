addpath('../include/')
files  = dir('../data/*.txt');
fid = fopen('../lighting/lights.txt', 'rb');    
temp =  textscan(fid,'%s %f %f %f');%[directory, '/',  imagename, '/lights.txt']; %lights
lightMatrix = [temp{2} temp{3} temp{4}];
L = -lightMatrix';

normals = genNormals(150, [0; 0; 1], 180);
[B_totalR, B_totalG, B_totalB] = genBmatrix(normals, L, '../data/', 1);

