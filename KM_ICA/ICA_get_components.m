function [W,activations,compvars] = ICA_get_components(data,Ncomps)

%Get ICA components from good piece of data using EEGLAB runica
%So use this routine to get ICA components
%
%INPUT
% data : [Nchn x time]
%OUTPUT
% W : [Ncomps x Nchn] Unmxing matrix, i.e. W = weights*sphere
%activations: [Ncomps x time] Components time activations

[weights,sphere,compvars] = runica(data,'pca',Ncomps); %From EEGLAB
W = weights*sphere;
activations = W*data;


