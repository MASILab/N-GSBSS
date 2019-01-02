addpath(genpath('fieldtrip-20180613'));
outdir=sprintf('%s/ODIResults',basedir);
mkdir(outdir);
for i=1:length(list)
        subj=num2str(list(i));
        inputdir = sprintf('%s/CiftiProcessed3/%s/MNINonLinear',subj);
        con14_r  = ft_read_cifti(sprintf('%s/Results/odi2T1/odi2T1_Atlas_s2.dtseries.nii',inputdir));
        data1=con14_r.dtseries;
        %% CON11
        data = [data1(find(con14_r.brainstructure==1))];
        data(isnan(data))=0;
        con11data_lh(:,i) = data;
	dlmwrite(sprintf('%s/%s_odi2T1_s2_lh.txt',outdir,subj),data)
        data = [data1(find(con14_r.brainstructure==2))];
        data(isnan(data))=0;
        con11data_rh(:,i) = data;
	dlmwrite(sprintf('%s/%s_odi2T1_s2_rh.txt',outdir,subj),data)
end

csvwrite(sprintf('%s/odi2T1_s2_male_WB.csv',[ con11data_lh; con11data_rh]' );
