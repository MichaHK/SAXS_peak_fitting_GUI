function [xn,yn,pospeakind,negpeakind]=smoothIt(x,y,smooth)

ys=fastsmooth(y,smooth);
yn=ys((smooth+2):(length(x)-smooth-2));
xn=x((smooth+2):(length(x)-smooth-2));
[pospeakind,negpeakind]=peakdetect(yn);