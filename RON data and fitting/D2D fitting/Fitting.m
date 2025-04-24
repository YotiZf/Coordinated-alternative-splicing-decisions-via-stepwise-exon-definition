% Add all subfolders from 'data2d-master' to MATLAB path
addpath(genpath('data2d-master'))

% Save the updated path to a file
savepath pathsa.m

% Initialize the Data2Dynamics (D2D) framework
arInit;

% Number of mutant datasets to load per rate parameter category
lenk1 = 62;    % Number of k1 mutants
lenk2 = 274;   % Number of k2 mutants
lenk3 = 69;    % Number of k3 mutants

% Choose model type: 1 for one-step model, else two-step model
model_type = 1;
fit = 1000;    % Number of LHS (Latin Hypercube Sampling) fitting iterations

% Load appropriate model based on model_type
if model_type == 1
    arLoadModel('one_step');
else
    arLoadModel('two_step');
end

% Define experiment/dataset label
data_label = 'RON_HEK293';

% Load WT (wild type) dataset
arLoadData(data_label);

% Load mutant datasets for k1 variants
for i = 1:lenk1
    arLoadData([data_label '_mut_k1_' num2str(i)]);
end

% Load mutant datasets for k2 variants
for i = 1:lenk2
    arLoadData([data_label '_mut_k2_' num2str(i)]);
end

% Load mutant datasets for k3 variants
for i = 1:lenk3
    arLoadData([data_label '_mut_k3_' num2str(i)]);
end

% Compile the model with all loaded data
arCompileAll;

% Define parameter search boundaries
limkon  = [-2 -3 1];    % log10 bounds for kon rates (association)
limkoff = [-2];         % initial value for koff (dissociation)
limdeg  = [-5 -6 -4];   % log10 bounds for degradation rates
limkspli = [-1 -3 1];   % log10 bounds for splicing rates

% Set kinetic parameters with log10-transformed bounds and initial values
arSetPars('k1', limkon(1), 1, 1, limkon(2), limkon(3));
arSetPars('k2', limkon(1), 1, 1, limkon(2), limkon(3));
arSetPars('k2a', limkon(1), 1, 1, limkon(2), limkon(3));
arSetPars('k2b', limkon(1), 1, 1, limkon(2), limkon(3));
arSetPars('k3', limkon(1), 1, 1, limkon(2), limkon(3));

arSetPars('kret', 0, 0, 0, -4, 1);  % return rate, fixed

% koff variants
arSetPars('k4',  limkoff, 0, 1, -5, 5);
arSetPars('k5a', limkoff, 0, 1, -5, 5);
arSetPars('k5b', limkoff, 0, 1, -5, 5);
arSetPars('k5',  limkoff, 0, 1, -5, 5);
arSetPars('k6',  limkoff, 0, 1, -5, 5);

% Splicing rate
arSetPars('kspli', limkspli(1), 1, 1, limkspli(2), limkspli(3));

% Degradation rates
arSetPars('kincl',  limdeg(1), 1, 1, limdeg(2), limdeg(3));  % Inclusion
arSetPars('kskip',  limdeg(1), 1, 1, limdeg(2), limdeg(3));  % Skipping
arSetPars('kdr1',   limdeg(1), 1, 1, limdeg(2), limdeg(3));  % Degradation 1
arSetPars('kdr2',   limdeg(1), 1, 1, limdeg(2), limdeg(3));  % Degradation 2

% Scaling parameter (e.g., signal strength), bounded
arSetPars('s', -3, 0, 1, -5, -2);

% Disable fitting of error parameters
ar.config.fiterrors = 0;

% Perform model fitting using Latin Hypercube Sampling
arFitLHS(fit)

% Save results to a .mat file
filename = [data_label, '_', num2str(model_type), '_', num2str(fit), '.mat'];
save(filename);
