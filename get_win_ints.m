function [xStart, xEnd] =  get_win_ints(Npts, seg_len, noverlap_per, fs)

% Npts is the length of the time series
%Length (sec) of segment, which will be averaged in computation of Cxy
%seg_len = 1; %Seconds
dL = round(seg_len.*fs);

%Overlap windows by 50%
noverlap = round(dL.*noverlap_per/100);

%Npts = size(X,2);
LminusOverlap = dL-noverlap;
%Compute the number of segments
k = (Npts-noverlap)./LminusOverlap;
%k = fix(k)-1;
k = fix(k);

%Get start and End sample segments
xStart = 1:LminusOverlap:k*LminusOverlap;
xEnd   = xStart+dL-1;