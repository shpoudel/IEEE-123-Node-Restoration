# IEEE-123-Node-Restoration

This repository containts the code for restoration of IEEE 123 node based on approach as detailed in the following paper:

S.Poudel and A. Dueby, "Critical load restoration using distributed energy resources for resilient power distribution system." IEEE Transactions on Power Systems 34.1 (2018): 52-63.

The scripts are written in MATLAB 2016a and optimization requires MATLAB to be linked with CPLEX. Please be familiar with mixed-integer linear programming. https://www.ibm.com/support/knowledgecenter/pl/SSSA5P_12.8.0/ilog.odms.cplex.help/refmatlabcplex/html/cplexmilp-m.html

MATLAB can be linked with CPLEX by simply following the steps given below in MATLAB command window:
1. Contains header m files, parsed p files and mex files for the CPLEX class and toolbox. 

    addpath (‘CPLEX install dir\cplex\matlab\x64_win64’)
    
    savepath
    
    
    
2. Contains MATLAB examples for the CPLEX API utilization.

    addpath (‘CPLEX install dir\cplex\examples\src\matlab’)
    
    savepath
