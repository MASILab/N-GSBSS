% Step1 create masks with specific location with different radius
simulateArtifact

% Step2 Simulate GM probability groups into 2 groups
%  Group1 - Original
%  Group2 - Apply different radius masks(1 to 5) and alter intensity from 0.1 - 1 in intervals of 0.1
simulateGMprobGroups

% Step 3 Register GM probablity maps for VBM statistics
registerGMprobGroups

% Step4 Apply GSBSS for both groups and all combinations
runGSBSSGMprobGroups