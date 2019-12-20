function [peaksAt,peakAmp,indexPeaks,xL,xR,yL,yR,w] =findingStartConditions (x,y,xpeak,numOfpeaks,smooth,findingPeakModel,SlopeThreshold,AmpThreshold,FitWidth)
w=[];xR=[];xL=[];yR=[];yL=[];
peaksAt=[];peakAmp=[];
if (findingPeakModel==5)
    if isempty (xpeak)
        [xpeak,ypeak]=ginput (numOfpeaks); %#ok<NASGU>
    end
    peakFound=length(xpeak);
    [peaksAt,peakAmp,indexPeaks]=closetox(x,y,xpeak);
elseif (findingPeakModel<3)
    [xs,ys,pospeakind,negpeakind]=smoothIt(x,y,smooth); %#ok<NASGU>
    indexPeaks=find((pospeakind>5)& (pospeakind<length(xs)-5));
    if ~isempty(indexPeaks)
        indexPeaks=smooth+2+pospeakind(indexPeaks);
        %% in smooth data we cut the first smooth+2 data points after smoothing
        peaksAt=x(indexPeaks);
        peakAmp=y(indexPeaks);
        peakFound=length(indexPeaks);
    else
        peakFound=0;
    end
else
    P=findpeaks(x,y,SlopeThreshold,AmpThreshold,round(smooth),FitWidth);
    if (P(1,1) == 0)
        peakFound=0;
    else
        sP=size(P);
        peakFound=sP(1);
    end
    [peaksAt,peakAmp,indexPeaks]=closetox(x,y,P(:,2));
end


if (((findingPeakModel==1)||(findingPeakModel==3)) && (peakFound>numOfpeaks))
    %if needed excatly number of peaks
    [peakAmps,ind]=sort(peakAmp);
    ind=fliplr(ind')';
    peakAmp=peakAmp(ind(1:numOfpeaks));
    indexPeaks=indexPeaks(ind(1:numOfpeaks));
    peaksAt=peaksAt(ind(1:numOfpeaks));

    peakFound=numOfpeaks;
end

lenlen=length(y);
if (peakFound>0)
for i=1:peakFound
    peaki=indexPeaks(i);
    ytempR=y(peaki+1:lenlen);
    ytempL=fliplr(y(1:peaki-1)')';

    % x0=peaksAt(i);
    yfindRt=find (ytempR./peakAmp(i)<0.5);
    if isempty (yfindRt)
        yfindR=1;
    else
        yfindR=yfindRt(1);
    end
    yfindLt=find (ytempL./peakAmp(i)<0.5);
    if isempty (yfindLt)
        yfindL=1;
    else
        yfindL=yfindLt(1);

    end
    xR(i)=x(peaki+yfindR);xL(i)=x(peaki-yfindL);yR(i)=y(peaki+yfindR);yL(i)=y(peaki-yfindL);
end
end
if (peakFound>0)
    w=abs(xR-xL);
end
% sorting the peaks
if (peakFound>1)
    [indexPeaks,si]=sort(indexPeaks);
    peaksAt(:)=peaksAt(si);
    peakAmp(:)=peakAmp(si);
    xL(:)=xL(si);xR=xR(si);w=w(si);yL(:)=yL(si);yR=yR(si);
    peaksAt(2:peakFound)=peaksAt(2:peakFound);
end



% to make sure they all will be sorted later on in the fitting




