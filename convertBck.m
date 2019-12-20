function [bck,bckPar]=convertBck (x,y,bck,bckPar,modelbck2)
bckold=bck;
st=30;
ybasepoints=bckPar(1);
newx=x(1:st);newy=y(1:st)-ybasepoints;
p = polyfit(newx,newy,1);
yq0=polyval(p,0);
[y12,x12,index12]=closetox(y,x,yq0/1.2);
mst=x12*sqrt(y12/(yq0-y12));
vs=[yq0 ,(1/x12)];
if (modelbck2 == 3)
    vs=[vs 0];
end
lenx=length(x);
newx=x;newy=bck-ybasepoints;
op=optimset;
options = optimset(op,'display','final','MaxFunEvals',1000,'TolFun',eps);
warning off
bckPar=nlinfit(newx,newy,@funLorenzian,vs,options);
warning on
% if (modelbck2==3)
%     if(bckPar(3)*0.01>10)
%         bckPar=nlinfit(newx,newy,@funLorenzian,[yq0,0,1],options);
%     end
% end

bck=ybasepoints+funLorenzian(bckPar,x);
bckPar=[ybasepoints bckPar];
% m=bckPar(3);
% figure (2);
% hold off
% plot (x,y,x,bck,'-r',x,bckold,'-k');
% figure (3)
% plot (x,y-bck);
% 

return

minu=min(y-bck);
if (minu<0)
   % bck=bck+minu;
   % bckPar(1)=bckPar(1)+minu;
    disp ('had to lower y0 xxx got to do bck');
end