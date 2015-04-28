# ICCP_DL_PS
Code for dictioanry based Photometric Stereo
This code is based on the algorithm proposed in the paper
"A Dictionary-based Approach for Estimating Shape and Spatially-Varying Reflectance", ICCP 2015
Zhuo Hui and Aswin Sankaranarayanan
When you use the code to build your algorithm, please cite this paper. 

Please contact the author Zhuo Hui if you have any problems with the code
huizhuo1987@gmail.com

Copy rights reserved by the authors listed above.

--------------------------------------------------------------------------------------------------------------------
# Prerequisite
 If you want to implement based on this code, please ensure that you have installed the cvx package and set up the root
 correctly. 
 You can download the package from the url http://cvxr.com/cvx/
--------------------------------------------------------------------------------------------------------------------
# set up
  Run the setup.m to set up the directory 
-----------------------------------------------------------------------------------------------------------------------  
# data
  1 surface normal: include surface normals of the bunny object and corresponding mask. 
  2 brdfs: include only one material BRDF in MERL, and you can download the others from the url:
            http://people.csail.mit.edu/wojciech/BRDFDatabase/brdfs/
            Note that you need to convert the binary file to .txt when you want to use the code. 
  3 syn_brdf: synthetic BRDF by random generating the non-negative coefficients, and project to the BRDF dictioanry. 
-----------------------------------------------------------------------------------------------------------------------  
# include
  1 brdf_solver_cvx.m: The function to get the per-pixel coefficients by solving the non-negative lasso problem
  
  2 brdfEst.m:         The function to run the brdf estimation for the estimated surface normals
  
  3 brdfMapping.m:     The function converts the lighting direction, view direction and surface normal to the corresponding 
				       intensity based on different materials
  
  4 genBmatrix.m:      The function used to generate the Bmatrix as indicated in the paper. 
  
  5 genNormals.m:      Generate the candidate normals based on uniform sampling on the sphere
  
  6 genVMap.m:         Generate the vicinity map based on the candidate normals 

  7 initialize.m:      Load the pre-calculated Bmatrix and vicinity map from the specified directory
  
  8 ms_normalEst.m:    Multi-scale searching scheme 
  
  9 relight.m:         Relighting the object based on the given surface normals and BRDF
-----------------------------------------------------------------------------------------------------------------------    
# lighting
  light.m:             The lighting direction based on USC dataset
					   http://gl.ict.usc.edu/LightStages/
-----------------------------------------------------------------------------------------------------------------------  
# scripts
  demo_generateB.m     The script used to demo how to generate the B matrix
  
  demo_normalEst.m:     The script used to demo how to get the normal estimates
-----------------------------------------------------------------------------------------------------------------------  
