%KM_script_getshowICA
% Use scipt to show ICA component timecourse, power, topography, and variance

% Bad or deleted channel info
%bdchns = [191 192];
%cloc(bdchns,:) = [];

%% ICA 
%Add EEGLAB to path
%eeglab_startup 

%Remove bad channels from data, d
%d(bdchns,:) = [];

Ncomps = 40;
[W,activations,compvars] = ICA_get_components(d,Ncomps); %d: [Nchn x time]
Winv = pinv(W);

%% Epoch ICA activations (for visualization purposes)
Ntrials = D.ntrials; %D is the SPM MEEG object, but can manually specify
Nsamples = D.nsamples; %Same as above
time = D.time; %Time axis

e_activ = reshape(activations,Ncomps,Nsamples,Ntrials);
me_activ = mean(e_activ,3);

%% Calculate spectrum of components activations
opt.dr = fs; %where fs is sampling rate
opt.pad=2^9;

specdat = calc_chn_pwr(activations',opt,'mtaper') % datain: [time x chn]

%%
hf1 = figure; h1 = gca;
figure;h2 = gca;

%% Highlight "curc" variable below, and use "cell advance +" in editor to advance 
curc = 9;
plot(h2,time,me_activ(curc,:));grid
figure(hf1)
GS_ICA_show(cloc,Winv,activations,1:size(activations,2),curc,compvars,specdat)