function [pRem,bckRem,x,y,pospeakind]=findBackgroundForNate (x,y,smooth)
format long

[x,y,pospeakind,negpeakind]=smoothIt(x,y,smooth);

lenneg=length (negpeakind);
SumdifRem=inf;
pRem=[];
bckRem=[];
for i=1:lenneg-1
    for j=i+1:lenneg
        linx=[x(negpeakind(i)) x(negpeakind(j))];
        logy=log([y(negpeakind(i)) y(negpeakind(j))]);
        p = polyfit(linx,logy,1);
        bcktmp = exp(polyval(p,x));
        dif=y-bcktmp;
%         figure (3)
%         hold off
%         semilogy (x,y);
%         hold on
%         semilogy (x,bcktmp,'-k');
%    
        if ~isempty (find(dif<0))
            [mind,minat]=min(dif);
%             figure (2)
%             plot (x,dif)
%             figure (3)
%             hold on
%             semilogy(x(minat),y(minat),'x');
            pp=p;
            %change=y(minat)-
            p(2)=p(2)-log(bcktmp(minat))+log(y(minat));
            bcktmp = exp(polyval(p,x));
            dif=y-bcktmp;
%             figure (3) 
%             hold on
%             semilogy (x,bcktmp,'-r');
        end
        sumdif=sum(dif);
        
     %   hold off
        if (SumdifRem>sumdif)
            pRem=p;
            sumdifRem=sumdif;
            bckRem=bcktmp;
        end
    end
end
% figure (3)
% semilogy (x,y);
% hold on
% semilogy (x,bcktmp,'-r');
% hold off

return

% 
% [ymin,yminindex]=min(y);
% xmin=x(yminindex);
% pleft=[];pright=[];
% for i=1:yminindex-1
%     linx=[x(i) xmin];
%     logy=log([y(i) ymin]);
%     p = polyfit(linx,logy,1);
%     bcktmp = exp(polyval(p,x));
%     dif=y-bcktmp;
%     figure (3)
%     semilogy (x,y);
%     hold on
%     semilogy (x,bcktmp,'-r');
%     hold off
%     if isempty (find(dif<0))
%         pleft=p;
%         sumdifleft=sum(dif);
%         bckleft=bcktmp;
%     end
% 
% 
% end
% for i=yminindex+1:length(y)
%     linx=[xmin x(i)];
%     logy=log([ymin y(i)]);
%     p = polyfit(linx,logy,1);
%     bcktmp = exp(polyval(p,x));
%     dif=y-bcktmp;
%     figure (3)
%     semilogy (x,y);
%     hold on
%     semilogy (x,bcktmp,'-r');
%     hold off
%     if isempty (find(dif<0))
%         pright=p;
%         sumdifright=sum(dif);
%         bckright=bcktmp;
%     end
% end
% 
% if (isempty(pleft))
%     p=pright;
%     bck=bckright;
%     return
% elseif (isempty(pright))
%     p=pleft;
%     bck=bckleft;
%     return
% elseif (sumdifright>sumdifleft)
%     p=pleft;
%     bck=bckleft;
%     return
% else
%     p=pleft;
%     bck=bckleft;
%     return
% end
% 
beep
