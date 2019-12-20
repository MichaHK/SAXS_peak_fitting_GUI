function [A,w,x0,y0,Abck,m,B]=ParfromV (vStart,bckmodel2)
lenv=length(vStart);
if (bckmodel2<3)
    lenB=3;
else
    lenB=2;
end
A=vStart(1:3:lenv-lenB);
w=vStart(2:3:lenv-lenB);
x0=vStart(3:3:lenv-lenB);
y0=vStart(lenv-lenB+1);
Abck=vStart(lenv-lenB+2);
if (bckmodel2<3)
    m=vStart(lenv-lenB+3);
elseif (bckmodel2==4)
    m=-2;
elseif (bckmodel2==5)
    m=-3;

end
if lenB>3
    B=vStart(lenv);
else
    B=0;
end


