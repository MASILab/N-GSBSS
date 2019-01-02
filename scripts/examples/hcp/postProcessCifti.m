addpath(genpath('fieldtrip-20180613'));
list=load('../subjlist.txt');
%% FMRI data - Cue,Probe,Delay
figure;
for i=1:length(list)
        subj=num2str(list(i));
        inputdir = sprintf('%s/CiftiProcessed2/%s/MNINonLinear',datadir,subj);
        probe_r  = ft_read_cifti(sprintf('%s/Results/conAll3_149s_test/conAll3_149s_test_Atlas_s2.dtseries.nii',inputdir));
        data1=probe_r.dtseries;
	%% CON11
        data = [data1(find(probe_r.brainstructure==1),2)];
        data(isnan(data))=0;
        cuedata_lh(:,i) = data;
        data = [data1(find(probe_r.brainstructure==2),2)];
        data(isnan(data))=0;
        cuedata_rh(:,i) = data;
	%% CON14
        data = [data1(find(probe_r.brainstructure==1),3)];
        data(isnan(data))=0;
        probedata_lh(:,i) = data;
        data = [data1(find(probe_r.brainstructure==2),3)];
        data(isnan(data))=0;
        probedata_rh(:,i) = data;
	%% CON15
        data = [data1(find(probe_r.brainstructure==1),4)];
        data(isnan(data))=0;
        delaydata_lh(:,i) = data;
        data = [data1(find(probe_r.brainstructure==2),4)];
        data(isnan(data))=0;
        delaydata_rh(:,i) = data;
end

 csvwrite(sprintf('%s/cue_LH.csv',datadir),cuedata_lh');
 csvwrite(sprintf('%s/cue_RH.csv'datadir),cuedata_rh');
 csvwrite(sprintf('%s/probe_LH.csv',datadir),cuedata_lh');
 csvwrite(sprintf('%s/probe_RH.csv'datadir),cuedata_rh');
 csvwrite(sprintf('%s/delay_LH.csv',datadir),cuedata_lh');
 csvwrite(sprintf('%s/delay_RH.csv'datadir),cuedata_rh');

csvwrite(sprintf('%s/cue_WB.csv',datadir),[ cuedata_lh; cuedata_rh]' );
csvwrite(sprintf('%s/probe_WB.csv',datadir),[ probedata_lh; probedata_rh]' );
csvwrite(sprintf('%s/delay_WB.csv',[ delaydata_lh; delaydata_rh]' );

