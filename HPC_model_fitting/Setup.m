function Setup(moo,fit)

pc = parcluster('local');
 
% get the number of dedicated cores from environment
num_workers = str2num(getenv('SLURM_NPROCS'));
 

websave('d2d-master.zip', 'https://github.com/Data2Dynamics/d2d/archive/refs/heads/master.zip')
unzip('d2d-master.zip')
addpath(genpath('d2d-master'))


arInit;

lenk1=62;
lenk2=274;
lenk3=69; 



% moo=1;%one step model
% % moo=2;%two step model


if moo==1;
    arLoadModel('exon_definition_one_step');
else
    arLoadModel('exon_definition_two_steps');
end


tilte=['HEKd2dcomitarerror'];
arLoadData(tilte );


for i=1:lenk1;

    arLoadData([tilte '_mut_k1_' num2str(i)]);
end

for i=1:lenk2;


    arLoadData([tilte '_mut_k2_' num2str(i)]);
end




for i=1:lenk3;

    arLoadData([tilte '_mut_k3_' num2str(i)]);
end



arCompileAll;



limkon=[-2 -3 1];
limkoff=[-2];
limdeg=[-5 -6 -4];
limkspli=[-1 -3 1];


arSetPars('k1',limkon(1),1,1,limkon(2),limkon(3));
arSetPars('alpha',0,1,1,-2,2);
arSetPars('bepa',0,1,1,-2,2);
arSetPars('k2',limkon(1),1,1,limkon(2),limkon(3));
arSetPars('k2a',limkon(1),1,1,limkon(2),limkon(3));
arSetPars('k2b',limkon(1),1,1,limkon(2),limkon(3));
arSetPars('k3',limkon(1),1,1,limkon(2),limkon(3));

arSetPars('kret',-2,0,1,-4,1);

arSetPars('k4',limkoff,0,1,-5,5);
arSetPars('k5a',limkoff,0,1,-5,5);
arSetPars('k5b',limkoff,0,1,-5,5);
arSetPars('k5',limkoff,0,1,-5,5);
arSetPars('k6',limkoff,0,1,-5,5);

arSetPars('kspli',limkspli(1),1,1,limkspli(2),limkspli(3));


arSetPars('kincl',limdeg(1),1,1,limdeg(2),limdeg(3));
arSetPars('kskip',limdeg(1),1,1,limdeg(2),limdeg(3));
arSetPars('kdr1',limdeg(1),1,1,limdeg(2),limdeg(3));
arSetPars('kdr2',limdeg(1),1,1,limdeg(2),limdeg(3));

arSetPars('s',-3,0,1,-5,-2);

arSetPars('f',0,0,1,-5,5);
arSetPars('sd',-2,0,1,-5,5);

ar.config.fiterrors=0; 

arFitLHS(fit, [], [], [], true);




filename = [tilte, '_', num2str(moo), '_', num2str(fit), '.mat'];  
save(filename);  



arSave([tilte,'_', num2str(moo),'lhs_' num2str(fit) '.mat'])


arChi2Test
