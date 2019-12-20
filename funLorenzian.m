function [y]=funLorenzian(v,x)
A=v(1);
w=v(2);
%y0=v(3)
if length(v)>2
    B=v(3);
else
    B=0;
end
y=A./(1+(w*x).^2+(B*x).^4);

