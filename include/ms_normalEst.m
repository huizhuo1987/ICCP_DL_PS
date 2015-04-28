%% This function implement the multi-scale search as proposed in the paper:
% A Dictionary-based Approach for Estimating Shape and 
% Spatially-Varying Reflectance
% Zhuo Hui and Aswin Sankaranarayanan
% ICCP 2015

%% Input:

% Bn: The created B matrix for each candidate normal and all the material 
%     in the BRDF database

% tSampleR,tSampleG, tSampleB: the stacked the inensities of the input 
%                              objects

% opt: 
%     opt.lid: the id of the lighting directions 
%                 in our case 1:253

%     opt.start: start from which scale, range: 1 to 5
%                for brute force search, just set start as 5.

%     opt.mapSet: the vicinity map associated with Bn

%     you can add some more constraints such as max iteration and
%     thresholding to stop the inner NNLS problem

%% Output
% idMat: the matrix which stores the id of the candidate normals that
%        minimize the cost metric in different scales
%        For example, for the test object with P normals, and Bn with S
%        scales, the size of idmat should be S by P

% errMat: the associated the error calculated based on the idMat


function [idMat, errMat] = ms_normalEst(Bn, tSampleR, tSampleG, tSampleB, opt)

lightsId = opt.lid;
startScale = opt.start;
mapSet = opt.mapSet;

scale =  size(Bn, 1);
errMat = cell(scale, size(tSampleR, 2));
idMat = zeros(scale, size(tSampleR, 2));

for i = 1:size(tSampleR, 2)
    tic
    yR = tSampleR(lightsId, i);
    yG = tSampleG(lightsId, i);
    yB = tSampleB(lightsId, i);
    % normalzied the input intenisty
    y = [ yR; yG; yB];
    y = y./norm(y);
    
    % initialize the searching set of ids
    pId = 1:size(Bn{startScale, 1}, 3);
    tic
    for ss = startScale:scale
        ee= [];
        for j = 1:length(pId)
            
            BnR = Bn{ss, 1}(lightsId, :, pId(j));
            BnG = Bn{ss, 2}(lightsId, :, pId(j));
            BnB = Bn{ss, 3}(lightsId, :, pId(j));
            B = [ BnR; BnG; BnB];
            % normalized the B
            B = B./repmat(diag(sqrt(B'*B))', size(B, 1), 1);
            
            % solve NNLS problem we drop the sparisty constraint here
            [~, ee(j)] = lsqnonneg(B, y);
        end
        [~, id] = sort(ee, 'ascend');
        errMat{ss, i} = ee;   
        idMat(ss, i) = pId(id(1));
        
        % we leave the first three ids with least error
        % and search the vicinity of the associated the ids in next level
        if (ss < scale)
            pId = unique([mapSet{ss}{pId(id(1))} mapSet{ss}{pId(id(2))} mapSet{ss}{pId(id(3))}]);
        end        
    end
    toc
 end  
    

