function draw_line(time,colr)
% draw_line(time,colr)
%INPUT
% time  :Time at which to draw vertical line (should correspond to time axis in
%           figure
% colr  :Color of line RGB [1 x 3]; default:  cyan, eg., red = [1 0 0] 

c = ylim;
if ~exist('colr','var')
    colr = [.145 .878 .937];
end

line([time time],c,'linewidth',1,'color',colr,'linestyle','--');