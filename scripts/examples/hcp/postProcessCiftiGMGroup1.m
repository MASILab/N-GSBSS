addpath(genpath('fieldtrip-20180613'));
list=load('grp1.txt');
for i=1:length(list)
        subj=num2str(list(i));
        inputdir = sprintf('%s/CiftiProcessed2/%s/MNINonLinear',datadir,subj);
        con14_r  = ft_read_cifti(sprintf('%s/Results/gmProb/gmProb_Atlas_s2.dtseries.nii',inputdir));
        data1=con14_r.dtseries;
	%% CON11
        data = [data1(find(con14_r.brainstructure==1))];
        data(isnan(data))=0;
        con11data_lh(:,i) = data;
        data = [data1(find(con14_r.brainstructure==2))];
        data(isnan(data))=0;
        con11data_rh(:,i) = data;
end

csvwrite(sprintf('%s/gmProb_s2_grp1_WB.csv',datadir),[ con11data_lh; con11data_rh]' );
