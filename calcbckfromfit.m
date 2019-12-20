function [bck,bckexp,bckPar]=calcbckfromfit (x,vEnd,bckmodel2)
lenv=length(vEnd);
if (bckmodel2<3)
    lenb=3;
    B=0;
else
    lenb=2;
    B=0;
end

bckbase=vEnd(lenv-lenb+1);
bckamp=vEnd(lenv-lenb+2);

if (bckmodel2==1)
    bckexp=-abs(vEnd(lenv-lenb+3));
elseif (bckmodel2==4);
    bckexp=-2;
 elseif (bckmodel2==5);
    bckexp=-3;   
else
    bckexp=abs(vEnd(lenv-lenb+3));
end
if (bckamp==0)
    bck=x.*0+bckbase;
else

    if ((bckmodel2==1) || (bckmodel2>3))
        bck=bckbase+bckamp.*(x.^bckexp);
    else
        bck=bckbase+bckamp./(1+(bckexp*x).^2+(B*x).^4);
    end
end
if (bckmodel2<3)
    bckPar=[bckbase bckamp bckexp];
else
    bckPar=[bckbase bckamp];
end
