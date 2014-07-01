function [xk, freq] = large_data_mtaper(ts, opt)
%[xk, freq, spec] = large_data_mtaper(ts, opt)

%[xk, freq] = large_data_mtaper
%
%Compute for large data sets containing many channels and windows
%
% Computation of tapered FT's for subsequent multitaper analysis: X(k,f)
%
% Output:
%  spec - Power Spectrum Density (log) [Nfreqs x Nchs]
%  xk - real array(nf, k, chan)
%         in units of ((time domain unit)/sqrt(Hz))^2.
        %Note that the power of each window was averaged
%  freq - vector of frequencies (in Hz)
%
% Input:
%   ts - time series (time, epoch, chan)
%
%   opt - option structure with the fields:
%        nw - time bandwidth parameter (e.g. 3 or 4)
%        k - number of data tapers kept, usually 2*nw -1 (e.g. 5 or 7 for
%             above)
%        pad - padding for individual window. Usually, choose power
%             of two greater than but closest to size of moving window.
%        dr - digitisation rate (in Hz)
%        fmin - min frequency to retain.
%        fmax - max frequency to retain.

[xk_curch, freq] = ts2xk(ts(:,:,1),opt);
nf  = size(xk_curch,1);
k = size(xk_curch,2);
nwins = size(xk_curch,3);

nch = size(ts,3);

%Init
xk = zeros(nf,k,nwins,nch);
%spec = zeros(nf,nch);

for i =1:nch
    %Calculate transform at particular channel over all freqs
    [xk_curch, freq] = ts2xk(ts(:,:,i),opt);
   
    %Mean power spectrum over all windows
    %xk(:,:,i) = mean(xk_curch.*conj(xk_curch),3);
    xk(:,:,:,i) = xk_curch;
    
    %Mean power spectrum over all windows and tapers
    %tmp = mean(xk_curch.*conj(xk_curch),3);
    %spec(:,i) = squeeze(mean(tmp,2));
end

%evals = eignvals_tapers(xk,fv,freq)
