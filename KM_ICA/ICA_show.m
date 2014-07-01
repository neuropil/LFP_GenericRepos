function ICA_show(chn,Winv,activations,time,curc,compvars,specdat)
% ICA_show(chn,Winv,activations,time,curc,compvars,specdat)
%
%INPUT
%   chn         :Get from: chn = read_BTIconfig('config',hdr);
%   Winv        :where, Winv = pinv(W); and W is from ICA_get_components.m            
%   activations :from ICA_get_components.m 
%   time        :Time axis (sec)
%   curc        :ICA component to view
%   compvars    :from ICA_get_components.m 
%   specdat     :[optional] Spectrum density, from specdat = calc_chn_pwr(activations',time,opt,'mtaper')
%                    Set opt.dr = sampling frequency, and opt.pad = nfft,
%                    such as 2^12


% if ~exist('hf','var')
% hf = gcf;
% end
% h = gca;

if ~exist('specdat','var')
    subplot(3,1,1)
plot(time,activations(curc,:));axis tight;title(curc);xlabel('Time')

subplot(3,1,2)
show_sens(chn.MEG,'data',Winv(:,curc),'showas','flat')

subplot(3,1,3)
plot(compvars,'o','markerfacecolor',[.2 .7 .6]);grid
draw_line(curc,[1 0 0])

else

subplot(2,2,1)
plot(time,activations(curc,:));axis tight;title(curc);xlabel('Time')

subplot(2,2,2)
show_sens(chn.MEG,'data',Winv(:,curc),'showas','flat')

subplot(2,2,3)
plot(specdat.freq,specdat.mean_spec(:,curc));grid;
xlim([0 70]);
xlabel('Frequency (Hz)')


subplot(2,2,4)
plot(compvars,'o','markerfacecolor',[.2 .7 .6]); 
draw_line(curc,[1 0 0])
%show_sens(chn.MEG,'data',Winv(:,curc),'showas','scene','senslabel','off')

end