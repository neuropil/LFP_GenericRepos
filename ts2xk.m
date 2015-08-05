function [xk, freq] = ts2xk(ts,opt)

% function [xk, freq] = ts2xk(ts,opt)
%
% Computation of tapered FT's for subsequent multitaper analysis: X(k,f)
%
% Output:
%    xk - complex array(nf, k, nwin, chan)
%         in units of (time domain unit)/sqrt(Hz).
%  freq - vector of frequencies (in Hz)
%
% Input:
%    ts - time series (time, epoch, chan)
%   opt - option structure with the fields:
%    nw - time bandwidth parameter (e.g. 3 or 4)
%     k - number of data tapers kept, usually 2*nw -1 (e.g. 5 or 7 for
%         above)
%   pad - padding for individual window. Usually, choose power
%         of two greater than but closest to size of moving window.
%    dr - digitisation rate (in Hz)
%  fmin - min frequency to retain.
%  fmax - max frequency to retain.

%no data - return
if isempty(ts)
    return
end

%number of time points in each window
win = size(ts,1);

%number of windows (epochs)
nwin = size(ts,2);

%number of channels
nch = size(ts,3);

%%%%%%%%%%%%%%%%%%%%% check input %%%%%%%%%%%%%%%%
%default nw = 3
if ~isfield(opt, 'nw')
    opt.nw = 3;
end

%default k = 2 * nw -1
if ~isfield(opt, 'k')
    opt.k = 2 * opt.nw - 1;
end

%default pedding = 2^nextpow2(win)
if ~isfield(opt, 'pad')
    opt.pad = 2^nextpow2(win);
end

%default digitisation rate = 1 Hz
if ~isfield(opt, 'dr')
    opt.dr = 1;
end

%default min frequency
if ~isfield(opt, 'fmin')
    opt.fmin = -inf;
end

%default max frequency
if ~isfield(opt, 'fmax')
    opt.fmax = inf;
end

%frequency vector
freq = 0:opt.dr/opt.pad:opt.dr/2;

fmin = max(find(freq<opt.fmin));
if isempty(fmin)
    fmin = 1;
end

fmax = min(find(freq>opt.fmax));
if isempty(fmax)
    fmax = numel(freq);
end

freq = freq(fmin:fmax);
nf = numel(freq);

%see tf_setup
norm = sqrt(1/opt.dr);

%%%%%%%%%%%%%%%%%%%%% computation %%%%%%%%%%%%%%%%
%get tapers
taper = dpss(win, opt.nw);

%setup output matrix
xk=i*ones(nf,opt.k,nwin,nch);
for ch = 1:nch
    for w = 1:nwin
        ts_win= ts(:,w,ch);
        xk0 = fft(ts_win(:,ones(1,opt.k)).*(taper(:,1:opt.k)),opt.pad);
        xk(:,:,w,ch) = xk0(fmin:fmax,:) * norm;
    end
end
