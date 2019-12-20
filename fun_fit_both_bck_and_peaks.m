function [y]=fun_fit_both_bck_and_peaks(v,x,model)
%%%% not good don't use
lenv=length(v-3);
numberOfpeaks=round((lenv-1)/3);

if ((model==1) || (model==2))
    y0=v(lenv);
elseif ((model==4) || (model==3))
    lenv=lenv+1;
end
    
%vStart=[peakAmp,w,peakAt,0];
A=v(1:3:lenv-1);
w=v(2:3:lenv-1);
x0=v(3:3:lenv-1);
bckA=v(lenv);
bckexp=v(lenv+1);
bckbase=v(lenv+2)
yt=zeros(1,length(x));
c=0.424660900144010; %1/(2*sqrt(ln(4)))
if (numberOfpeaks>0)

    for i=1:numberOfpeaks
        %   if (i>1)
        %      x0(i)=x0(i)+x0(1);
        %  end
        w2=w(i).^2;
        if (model==1 || model==3)
            yt(i,:)=bckbase+(bckA.^bckexp)+A(i).*w2./(eps+4*(x-x0(i)).^2+w2);
        elseif (model==2 || model==4)
            yt(i,:)=bckbase+(bckA.^bckexp)+(A(i).*exp(-2.*((x-x0(i)).^2)./(eps+c.*w2));
        end
    end
end
if (numberOfpeaks>1)
    y=sum(yt);
else
    y=yt;
end
if ((model==1) || (model==2))
    y=y+y0;
end


