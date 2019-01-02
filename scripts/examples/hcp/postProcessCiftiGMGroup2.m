addpath(genpath('fieldtrip-20180613'));
list=load('grp2.txt');
radius=[ 3 4 5];
perc = [2 4 6 8 10];
    for k=1:length(radius)
        for j=1:length(perc) 
        entry=sprintf('sim_r%d_p%d',radius(k),perc(j))

for i=1:length(list)
        subj=num2str(list(i));
        inputdir = sprintf('%s/CiftiProcessed2/%s/MNINonLinear',datadir,subj);
        con14_r  = ft_read_cifti(sprintf('%s/Results/gmProb_%s/gmProb_%s_Atlas_s2.dtseries.nii',inputdir,entry,entry));
        data1=con14_r.dtseries;
	%% CON11
        data = [data1(find(con14_r.brainstructure==1))];
        data(isnan(data))=0;
        con11data_lh(:,i) = data;
        data = [data1(find(con14_r.brainstructure==2))];
        data(isnan(data))=0;
        con11data_rh(:,i) = data;
end

csvwrite(sprintf('%s/gmProb_s2_%s_grp2_WB.csv',datadir,entry),[ con11data_lh; con11data_rh]' );
end
end
