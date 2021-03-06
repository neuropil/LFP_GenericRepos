%Data type: Preprocessed LFP data
%Graph output:
% 1 - Scatterplot of LFP1, LFP2, LFP3 beta band power vs depth.
% 2 - Scatterplot of LFP1, LFP2, LFP3 average amplitude vs depth
function testFUNjat
%% isolating  data
for i=1:length(LFPdataST.depthVals)
    dat1 = LFPdataST.LFP1(i,:);
    dat2 = LFPdataST.LFP2(i,:);
    dat3 = LFPdataST.LFP3(i,:);
    fs = LFPdataST.fs; %Sampling freq
    opt.dr = fs; % Parameters for spectral decomposition
    opt.pad = 2^11; % Parameters for spectral decomposition
    var1 = dat1(~isnan(dat1));
    var2 = dat2(~isnan(dat2));
    var3 = dat3(~isnan(dat3));
    specdat.lfp1 = calc_chn_pwr_JAT(var1,opt,'mtaper');
    specdat.lfp2 = calc_chn_pwr_JAT(var2,opt,'mtaper');
    specdat.lfp3 = calc_chn_pwr_JAT(var3,opt,'mtaper');
    
    for n= 1:3 %loop for CLFP1,2,3 data
        if n==1
            transformed_signal=specdat.lfp1.mean_spec;
        end
        if n==2
            transformed_signal=specdat.lfp2.mean_spec;
        end
        if n==3
            transformed_signal=specdat.lfp3.mean_spec;
        end
        frequency_scale=specdat.lfp1.freq;
        
        %beta notch filer
        lower_limit=12;
        upper_limit=40;
        ll_f=find(frequency_scale>=lower_limit);
        ul_f=find(frequency_scale<=upper_limit);
        beta_range_start=ll_f(1);
        beta_range_end=ul_f(end);
        
        lfp_names={'lfp1','lfp2','lfp3'};
        beta_signal=transformed_signal(beta_range_start:beta_range_end);
        beta_frequency=frequency_scale(beta_range_start:beta_range_end);
        % Determining the length of the filtered signal
        beta_signal_length= length(beta_signal);
        % Calculating the root-mean-squared power of the filtered signal
        band_power = (norm(beta_signal)/sqrt(beta_signal_length)).^2;
        % Calculating the average
        a_f=mean(beta_signal);
        
        %organize filtered components into structure by band
        specdat.(lfp_names{n}).beta_filtered(:,i)=beta_signal;
        specdat.(lfp_names{n}).avg_filtered(:,i)=a_f;
        specdat.(lfp_names{n}).band_power(:,i)=band_power;
    end
%     depths=LFPdataST.depthVals*0.001;
    % Graph for band power
%     figure(1) %beta
%     hold on; grid;
%     plot(depths(i), specdat.lfp1.band_power(:,i),'or',...
%         depths(i), specdat.lfp2.band_power(:,i),'og',...
%         depths(i), specdat.lfp3.band_power(:,i),'ob')
%     xlabel('Depth (mm)');ylabel('Band Power');
%     title('Beta band: 12-40Hz band power');
%     legend('CLFP1','CLFP2','CLFP3');
%     ylim([0 3*10^4]);
%     
%     %% Graph for average amplitude
%     figure(2) %beta
%     hold on; grid;
%     plot(depths(i), specdat.lfp1.avg_filtered(:,i),'or',...
%         depths(i), specdat.lfp2.avg_filtered(:,i),'og',...
%         depths(i), specdat.lfp3.avg_filtered(:,i),'ob')
%     xlabel('Depth (mm)');ylabel('Amplitude');
%     title('Beta band: 12-40Hz Average Amplitude');
%     legend('CLFP1','CLFP2','CLFP3');
%     ylim([0 150]);
end