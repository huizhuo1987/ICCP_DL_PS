# ICCP_DL_PS
Code for dictioanry based Photometric Stereo
This code is based on the algorithm proposed in the paper
"A Dictionary-based Approach for Estimating Shape and Spatially-Varying Reflectance", ICCP 2015
Zhuo Hui and Aswin Sankaranarayanan
When you use the code to build your algorithm, please cite this paper. 

--------------------------------------------------------------------------------------------------------------------
# prerequisite
 If you want to implement based on this code, please ensure that you have installed the cvx package
 You can download the package from the url http://cvxr.com/cvx/
--------------------------------------------------------------------------------------------------------------------
# data
  # surface normal: include surface normals of the bunny object and corresponding mask. 
  # brdfs: include only one material BRDF in MERL, and you can download the others from the url:
            http://people.csail.mit.edu/wojciech/BRDFDatabase/brdfs/
            Note that you need to convert the binary file to .txt when you want to use the code. 
            
  # syn_brdf: synthetic BRDF by random generating the non-negative coefficients, and project to the BRDF dictioanry. 
-----------------------------------------------------------------------------------------------------------------------  
# include
  # brdf_solver_cvx.m: The function to calculate the per-pixel coefficients by solving the non-negative lasso problem
  # 


