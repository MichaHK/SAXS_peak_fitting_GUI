function [x,y,peaky,bck,startx,endx,m,bckPar]=dobkg (x,y,startx,endx,handles,modelbck,modelbck2,slopeWhichIsFixed)


global data matfilename %#ok<NUSED,NUSED>

% [newxfull,peaky,bck,startx,endx,vStart,vEnd,m]=dobkg (x,y,startx,endx)
% find a background and a fit after substraction
%
%
% []= dobkg (x,y,startx,endx)
% x,y - input vectors
% startx,endx - fitting boundaries for background linear fit in loglog scale
%               if not defined then ginput will ask for the 2 point
%
% modelbck- how to find the background;
% modelbck2- model of the background (1: Aq^m +c 2:A/m^2+q^2 3:A/(m^2+q^2+B^2) 4: Aq^-2 +c 5: Aq^-3 +c)
% [newxfull,peaky,bck,startx,endx,vStart,vEnd]=dobkg (..)
%
% newxfull,peaky - new x,y vectors after background substraction
% startx,endx - fitting boundaries for background linear fit in loglog scale
%               if not defined in input then the result from graphic input
% bck - background line.
% vStart,vEnd - start vector and end vector for lorenzian fit to the peak
%               after background substraction. each verctor contains: [y0,A,w,x0]
% yEnd - the fitting curve
% m- the slope of the backgroud
% bckPar= Parameters for background
% bck= bckAmp*x^m + nckBase
% slopeWhichIsFixed = fixed m, if empty then fit it


format long
bckBase=0;bckAmp=0;
if ((nargin < 4)||(startx<=0)||(endx<=0))

    axes(handles.axes1);
    hold off


    if ((modelbck==1) || (modelbck==5))
        plotingFigures (handles,1,x(1:140),y(1:140),'o',false);
        axis tight
        refresh
        [xi,yi]=ginput (2); %#ok<NASGU>
        startx=min(xi);endx=max(xi);
    else
        xl=xlim;
        startx=xl(1);endx=xl(2);
    end
%     display (['starting at:', num2str(startx)]);
%     display (['ending at:', num2str(endx)]);



end
if ((modelbck==5) || (modelbck ==6))
    basepoints=str2double(char(get(handles.basepoints,'String')));
    len=length(x);
    ybasepoints=mean(y(len-basepoints:len));
    bckBase=ybasepoints;
else
    ybasepoints=0;
end
smooth=str2double(char(get(handles.smoothpoints,'String')));
if (modelbck==3)
    [p,newbck,newxfull,newyfull,pospeakind]=findBackgroundForNate (x,y,smooth); %#ok<NASGU,NASGU>
    if (length(p)>0)
        m= p(1); bckAmp=log(p(2));
        bck = exp(polyval(p,x));
    else
        m=0;
        bck=0*x;
    end


elseif (modelbck==4)
    m=0;
    bck=zeros(length(x),1);
    newbck=bck;
    newxfull=x;newyfull=y;
    bckPar=[];
else

    fxindex=find((x>=startx)&(x<=endx));
    if (length (fxindex) < 1)
        st=1;en=1;
    else
        st=fxindex(1);
        en=fxindex(length(fxindex));
    end



    newx=x(st:en);newy=y(st:en)-ybasepoints;
    lnx=log(newx);lny=log(newy);
    if ((modelbck==1) || (modelbck==5))
        try
        p = polyfit(lnx,lny,1);
        p = real (p);
        catch
            p=[0 0];
        end
    elseif ((modelbck==2) || (modelbck==6))


        linex=log([x(st) x(en)]);
        liney=log([y(st) y(en)]-ybasepoints);
        p = polyfit(linex,liney,1);

    end
    if ~isempty (slopeWhichIsFixed)
        p(1)=slopeWhichIsFixed
    end
    if (modelbck2==4)
        p(1)=-2;
        bckPar=[bckBase bckAmp];
    elseif (modelbck2==5)
        bckPar=[bckBase bckAmp];
        p(1)=-3;
    end
    m= p(1);
    bckAmp=exp(p(2));
     
    if (modelbck2==4)
        bckPar=[bckBase bckAmp];
    elseif (modelbck2==5)
        bckPar=[bckBase bckAmp];
    else
        bckPar=[bckBase bckAmp m];
    end
    bck = exp(polyval(p,log(x)))+ybasepoints;
    
    
   
end
if (modelbck2>1)&&(modelbck2<4)

    %conver bck to lorenzian:  
    disp ('convert bck to lorenzian');
    [bck,bckPar]=convertBck (x,y,bck,bckPar,modelbck2);
end

peaky=y-bck;


%%finding the fitting starting parameters
return



