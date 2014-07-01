function [y,fs,t] = make_sqpulse(filename)
% [y,fs,t] = make_sqpulse(filename)
%Makes paired-click auditory stimulus for gating experiment. Experiment
% parameters can be modified below.
%
%INPUT
%   filename    - Optional.  If exists will create .wav file with this
%                 filename. eg enter 'gating_DBS.wav'
%OUTPUT
%   y           - Signal (single precision)
%   fs          - Sampling frequency (Hz)
%   t           - Time vector (sec)
%
% Author: Keeran Maharajh
% Date: 04/11/2014

%Input parameters
Nstimprs = 16; %Number of stimulus pairs
blrst = 2; %Time of rest between blocks (min) 
Nblcks = 3; %Number of blocks
tstrt = 5; %Time (sec) before start of first click in experiment

isi = 10; %Time between stimuli pairs (sec)
%pd = 0.04; %Pulse duration (msec)
pd = 0.04; %Pulse duration (msec)

ipd = 0.5; %Inter-pulse duration(sec), i.e., time between each of the paired click 
%fs = 25000; %Sampling frequency (Hz)
fs = 25000; %Sampling frequency (Hz)

%Convert to samples
s_tstrt = round(tstrt*fs);
s_blrst = round(blrst*60*fs);
s_pd = round(fs*pd./1000);
s_ipd = round(fs*ipd);
s_isi = round(fs*isi);

%Init
y_st = zeros(1,s_tstrt);
y = [];

for Ki=1:Nblcks
    if Ki==1
        y = [y_st y]; %Add silent period before start of experiment (if desired)
    end
    
    for i=1:Nstimprs
        y_cur = [ones(1,s_pd) zeros(1,s_ipd) ones(1,s_pd)]; %Click pair
        y = [y y_cur]; % Append 
        if i<Nstimprs %  Add ISI
            y = [y zeros(1,s_isi)]; 
        end
    end
    
    if Ki < Nblcks % Add block rest
        y = [y  zeros(1,s_blrst)];
    end
end
    
y = single(y).*0.5;

t = (1:length(y))./fs; %Time vector 

figure;plot(t,y);grid

if exist('filename','var')
    wavwrite(y,fs,filename); %To save to .wav file
end
