function [ts_out,xStart,xEnd] = create_ts_mtaper(X, seg_len, noverlap_per, fs)
%INPUT
% X     - [Npts x Nchn]
% seg_len   - Segment length (sec)
%
%OUTPUT
% ts_out    - [Npts x Nsegs x Nchns]

% Npts is the length of the time series
%Length (sec) of segment, which will be averaged in computation of Cxy

Npts = size(X,1);
Nchns = size(X,2);

[xStart, xEnd] =  get_win_ints(Npts, seg_len, noverlap_per, fs);

Nsegs = length(xEnd);
Npts = (xEnd(1) - xStart(1)) + 1;

%Initialize
ts_out = zeros(Npts, Nsegs, Nchns);

for i = 1:Nsegs
    ts_out(:,i,:) = X(xStart(i):xEnd(i),:);
end

