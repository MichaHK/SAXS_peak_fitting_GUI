function [y]=fun(v,x,model,funloglog,bckmodel2,bckPar,numofpeaksIN)
lenv=length(v);
lenB=length(bckPar);
if (bckmodel2>3)
        bckPar=v(lenv-1:lenv);
        bckPar=bckPar(1:2);
        lenB=2;
end
if isempty(bckPar)
    flagnobck=true;
    if (bckmodel2<3)
        bckPar=v(lenv-2:lenv);
        lenB=3;
    elseif (bckmodel2>3)
        bckPar=v(lenv-2:lenv);
        lenB=2;
    else
        bckPar=v(lenv-3:lenv);
        lenB=4;
    end
else
    flagnobck=false;
end
if ((model==1) || (model==2))
    %    y0=v(lenv-2);
    %   bckPar(1)=v(lenv);

    v=[v bckPar(2:lenB)];
    %    lenv=lev+2;
elseif ((model==4) || (model==3))
    %   lenv=lenv+3;
    %  y0=0;
    v=[v bckPar(1:lenB)];
    % elseif (model==5)
    %     y0=v(lenv-2);
    %     bckamp=v(lenv-1);
    %     bckexp=v(lenv);
end
lenv=length (v);
lenvneed=(3*numofpeaksIN)+length(bckPar);
if (lenv>lenvneed)
    v=v(1:lenvneed);
elseif (lenv<lenvneed)
    if ((lenv+lenB)==lenvneed)
        v=[v bckPar];
    else
        beep
        disp ('go to fun.m line 35 - we have a problem len vec in is smaller than needed');
        v=[v (1:lenvneed-lenv).*0];
    end
end
lenv=length (v);
if (sum(bckPar)==0)
    v(lenv-lenB+1:lenv)=bckPar;
end
[A,w,x0,y0,Abck,m,B]=ParfromV (v,bckmodel2);
if (bckmodel2==4)
    m=-2;
end
if (bckmodel2==5)
    m=-3;
end

numberOfpeaks=length(A);
%vStart=[peakAmp,w,peakAt,0];
% A=v(1:3:lenv-3);
% w=v(2:3:lenv-3);
% x0=v(3:3:lenv-3);
yt=zeros(1,length(x));
c=0.424660900144010; %1/(2*sqrt(ln(4)))

if (funloglog<3)
    x=exp(x);
end

if (numberOfpeaks>0)

    for i=1:numberOfpeaks
        %   if (i>1)
        %      x0(i)=x0(i)+x0(1);
        %  end
        w2=w(i).^2;
        if (model==1 || model==3 || model==5)
            yt(i,:)=A(i).*w2./(eps+4*(x-x0(i)).^2+w2);
        elseif (model==2 || model==4)
            yt(i,:)=A(i).*exp(-2.*((x-x0(i)).^2)./(eps+c.*w2));
        
        end
    end
end
if (numberOfpeaks>1)
    y=sum(yt);
else
    y=yt;
end
yneg=find(y<eps);
y(yneg)=-y(yneg).^5;

%
%  if ((model==1) || (model==2))
%      y=y+y0;
%  elseif (model==5)
%      y=y+bckamp*(x.^(bckexp))+y0;
%  end
if ~(flagnobck)
    bckc=calcbckfromfit (x,v,bckmodel2);
    s1=size(y);s2=size(bckc);
    if (s1(1)==s2(1))
        y=y+bckc;
    else
        y=y+bckc';
    end
end
if ((funloglog==1) || (funloglog==3))
    y=log(abs(y)+eps);
end
if (length(find(~isfinite(y)))>0)
    beep
end
