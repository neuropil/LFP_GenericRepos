function [X_fft,f] = large_data_FFT(ts_out,opt)
% X_fft = large_data_FFT(ts_out,opt)
%
% X_fft [freq x Nhammingwin x epochs]
% NOTE: THis function, unlike Mtaper, is for only ONE channel at a time

%Detrend flag
detrnd_flag = 0;
winlen = 2.5; %Seconds

if ~isfield(opt,'noverlap'); opt.noverlap = 50; end
if ~isfield(opt,'seg_len'); opt.seg_len = 0.30; end %sec
if ~isfield(opt,'pad'); opt.nfft = 128; else opt.nfft = opt.pad; end %sec

fs = opt.dr;
seg_len = opt.seg_len;
noverlap = opt.noverlap;
nfft = opt.nfft;

Nwins = size(ts_out,2);
Npts = size(ts_out,1);

%[xStart, xEnd] = get_win_ints(X, noverlap);
[xStart, xEnd] = get_win_ints(Npts, seg_len, noverlap, fs);

dL = round(seg_len*fs);
win = hamming(dL);

L = length(xEnd);
f = fs*(0:nfft/2)./nfft;

% %Detrend Data 
% if detrnd_flag == 1
%     wnln_smp = round(winlen*fs);
%     [m,s] = slidestat(ts_out, wnln_smp);
%     ts_out = ts_out - m;
% end

%Compute FFT for all channels and segments
X_fft = zeros(length(f),L,Nwins);
for i = 1:L
    for j = 1:Nwins
        %Apply windowing function to data
        X_cur = ts_out(xStart(i):xEnd(i),j).*win;
        %Calculate FFT on windowed data
        X_fft_all= fft(X_cur,nfft);
        X_fft(:,i,j) = X_fft_all(1:(nfft/2)+1);
    end
end