% Script for power analysis using multitaper spectral decomposition

dat = [CLFP1;CLFP2;CLFP3];
fs = 800; %Sampling freq

% Remove mean
mdat = remove_mean(dat');

% Parameters for spectral decomposition
opt.dr = fs;
opt.pad = 2^11;

specdat = calc_chn_pwr(mdat,opt,'mtaper');

figure;plot(specdat.freq,specdat.mean_spec);grid
xlabel('Frequency (Hz)');ylabel('Amplitude');title('LFP Multitaper Spectrum')