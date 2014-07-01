function y = remove_mean(x)
% y = remove_mean(x)
%Remove mean for each column
%INPUT
% x     - [time x Nchn]

Npts = size(x,1);
xm = mean(x,1);
y = x - repmat(xm,Npts,1);


