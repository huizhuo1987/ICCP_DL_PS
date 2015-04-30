function [Bn, canNormal, mapSet] = initialize(directory)

B_files = dir([directory '/Bn*.mat']);
for kk = 1:length(B_files)
    load([directory B_files(kk).name]);
    canNormal{kk} = normals;
    Bn{kk,1} = B_totalR; 
    Bn{kk,2} = B_totalG; 
    Bn{kk,3} = B_totalB; 
end


M_files = dir([directory '/map*.mat']);
mapSet = {};
for kk = 1:length(M_files)
    load([directory M_files(kk).name]);
    mapSet{kk} = idxSet;
end
