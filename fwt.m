function [wave,freqs,coi] = fwt(x, dt, pad, dfreq, freqrnge,mother)
%[wave,freqs,coi] = fwt(x, dt, pad, dfreq, freqrnge,mother)
%
%
%INPUTS:
%   x   :Data (Note can be a matrix [time x nchns])
%   dt  :Sampling period
%   pad :Flag. Enter 1 to pad, 0 otherwise
%   dfreq :Frequency steps to use for transform 
%   freqrnge: 2 element vector [lowfreq highfreq]
%   mother: Should currently use default 'MORLET'
%           These could be 'DOG' or 'PAUL'

%Note that fourier scale(period) = 1.03*wavelet scale (Morlet, w0=6)
% fourier_factor = 4*pi/(2*m+1); , where m = w0;
% value is coi is dubious, it should be something like:
%   coi = sqrt(2)/freqs*1.03 (for Morlet,m=6)
%

if (nargin < 6), mother = 'MORLET'; end

if (nargin < 5), freqrnge = -1; end
if (nargin < 4), dfreq = -1; end
if (nargin < 3), pad = 0; end
if (nargin < 2)
	error('Must input a vector data,Y, and sampling period')
end

%Added this 
pad = 0;

[n1,nchns] = size(x);

if (freqrnge == -1), freqrnge = [1 1/2*dt]; end
if (dfreq == -1), dfreq = 1; end

%....construct time series to analyze, pad if necessary
%x(1:n1) = Y - mean(Y);
if (pad == 1)
	base2 = fix(log(n1)/log(2) + 0.4999);   % power of 2 nearest to N
	x = [x;zeros(2^(base2+1)-n1,nchns)];
end
n = size(x,1);

%....construct wavenumber array used in transform [Eqn(5)]
k = 1:fix(n/2);
k = k.*((2.*pi)/(n*dt));
k = [0., k, -k(fix((n-1)/2):-1:1)];

%....compute FFT of the (padded) time series
f = fft(x);    % [Eqn(3)]

%....construct SCALE array & empty PERIOD & WAVE arrays
freqs = freqrnge(1):dfreq:freqrnge(end);
periods = 1./freqs;
 scale = periods./1.03;  %These are the s_j's
%scale = periods;  %These are the s_j's
J1 = length(scale);
%wave = zeros(J1,n,nchns);  % define the wavelet array
wave = zeros(J1,n1,nchns);  % define the wavelet array

%wave = wave + i*wave;  % make it complex

% loop through all scales and compute transform
k0 = 6;
coi = 1.03/sqrt(2); % Cone-of-influence [Sec.3g]
nk = length(k);
for a1 = 1:J1
    expnt = -(scale(a1).*k - k0).^2/2;
   %norm = sqrt(scale(a1)*k(2))*(pi^(-0.25))*sqrt(nk);    % total energy=N   [Eqn(7)]
    norm = sqrt(2*pi*scale(a1)./dt);   
    %norm = 1;
    daughter = norm*exp(expnt).*(k > 0.)*pi^(-0.25); % Heaviside step function
   
% daughter = wave_bases(mother,k,scale(a1),-1);
daughter = (daughter)'; 
	for kk=1:nchns
        tmp = ifft(f(:,kk).*daughter);
        wave(a1,:,kk) = tmp(1:n1);
    end
    %wave(a1,:,:) = ifft(f.*repmat(daughter,1,nchns));  % wavelet transform[Eqn(4)]
end

coi = coi*dt*[1E-5,1:((n1+1)/2-1),fliplr((1:(n1/2-1))),1E-5];  % COI [Sec.3g]
%wave = wave(:,1:n1,:);  % get rid of padding before returning

%wave = abs(wave);