function dat = calc_chn_pwr(data,opt,spectype)
% dat = calc_chn_pwr(data,time,opt,spectype)
%Calculates PSD of potentially long data set, and therefore will epoch the
%data into 5 second segments [defualt], if want to use shorter segments
%then set opt.seg_len to desired length of segment (seconds)
%
%INPUT
% data: [time x chn]
% time: Time [units of sec]
% opt: [structure], see below, make sure to specifiy opt.dr = [sampling freq.]
% spectype: string, default ['FFT'] or can use 'mtaper' 
%
%Usage example: 
% specdat = calc_chn_pwr(activations',opt,'mtaper')
%
%N.B. the below was hacked from previous .m files
%/CO_MEG/mtapers/sleep_mtaper_script.m and sleep_FFT_script.m
% /BTISPM/kmspm_calc_chn_pwr.m

if ~exist('spectype','var')
    spectype = 'FFT';
end

if ~isfield(opt,'noverlap'); opt.noverlap = 0; end
if ~isfield(opt,'seg_len'); opt.seg_len = 5; end %sec
if ~isfield(opt,'pad'); opt.nfft = 2^9; else opt.nfft = opt.pad; end %sec
%if ~isfield(opt,'dr'); opt.dr = 508.63; end

[e_samp,Nchns] = size(data);
chnlst = 1:Nchns;

s_samp = 1;
e_samp = e_samp;

fs = opt.dr;
eplen = opt.seg_len; %Length of each epoch (segment) sec

%Structure continuous time series into epochs
%ts_out [time x epochs x chn]
[ts_out,xStart,xEnd] = create_ts_mtaper(data(s_samp:e_samp,:),eplen,0,fs );

%Get rid of bad epochs
%bad = find_bad_epochs_mtaper(ts_out);
%ts_out(:,bad.ep,:)=[];
%bad.time = time(xStart([bad.ep]) + bad.time);

%Convert to femtotesla
%ts_out=ts_out.*1e15;

%Init
if strcmpi(spectype,'FFT')
for i =1:length(chnlst)
%Calculate complex spectral estimations using multitapers
[dat.xk(:,:,:,i), dat.freq] = large_data_FFT(ts_out(:,:,chnlst(i)), opt);
% dat.xk : [freq x Nhammingwin x epochs]

%Calculate spectral power averaged over tapers and epochs
dat.spec(:,i) = calc_taper_pwr(dat.xk(:,:,:,i));
end

elseif strcmpi(spectype,'mtaper')
%Calculate complex spectral estimations using multitapers
[dat.xk, dat.freq] = large_data_mtaper(ts_out, opt);

Neps = size(dat.xk,3);
Nfreqs = size(dat.xk,1);
Nchns = size(dat.xk,4);

    %Init
dat.spec = zeros(Nfreqs,Nchns,Neps);

%Calculate spectral power averaged over tapers and epochs
for i =1:Neps
    dat.spec(:,:,i) = calc_taper_pwr(dat.xk(:,:,i,:));
end
dat.mean_spec = calc_taper_pwr(dat.xk);

else error('Must specify spectral estimation type')
end

%Write to structure
%dat.badeps = bad;
%dat.time = D.time;
dat.xStart = xStart;
dat.xEnd = xEnd;


