function spec=calc_taper_pwr(xk);
%XK2SP spec=xk2sp(xk);
%   xk is 4D array:
%      frequency x taper x time x channel
%   spec is 2D array:
%      frequency x channel
%
%   spec=mean(log(mean(xk.*conj(xk),tapers)),time)
%or
%   spec=mean(log(mean(xk,2)),3)

spec=squeeze( ...
              mean( ...
                       mean( ...
                               xk.*conj(xk) ...
                           ,2) ...
                   ,3) ...
            );
