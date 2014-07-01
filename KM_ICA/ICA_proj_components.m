function data_red = ICA_proj_components(data,W,whchcomps)
% data_red = ICA_proj_components(data,W,whchcomps)
%Project specified ICA components back to sensor space to get reduced data
%set which consists of a mixture of those components
%INPUT
% data : [Nchn x time]
% W :Unmixing matrix [Ncomps x Nchn]
% whchcomps : [1 x k], vector of components indices to keep

%Get activations for full data
activations = W*data; %[Ncomps x time]

%Mixing matrix
Winv = pinv(W); %[Nchn x Ncomps]

%Project reduced components back to sensor space
data_red = Winv(:,whchcomps)*activations(whchcomps,:);
