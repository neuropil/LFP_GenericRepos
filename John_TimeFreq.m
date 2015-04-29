% For the time-freq images, I use wavelets to generate a point estimate of
% the frequency.

%INPUTS:
%   x   :Data (Note can be a matrix [Ntime x Nchns])

% Wavelet Parameters
dfreq = 1; % decrease this number for nicer "smoother" looking images 
freqrnge = [1 50]; %Frequency Range (Hz) to calculate transform
pad = 1; % Padding flag [1] for yes
fs  = 1502.40; % Sampling freq (Hz)
dt = 1./fs;

[tfData,freqs] = fwt(x, dt, pad, dfreq, freqrnge); %Output: [Nfreqs x Nt x Nchn] complex
amp = abs(tfData); %Amplitude

%Plot
figure;
imagesc(timevec*1000,freqs,amp(:,:,1));colorbar;axis xy;
title('LFP 1');ylabel('Freq(Hz)');xlabel('Time (ms)');
    
    