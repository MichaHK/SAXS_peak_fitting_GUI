function [vStart,peakAt,peakAmp,indexPeaks,xL,xR,yL,yR,w,vEnd,yEnd,xpeaks]= Fittingone(handles,x,peaky,xpeaks,yraw,bckPar,hObject)

smooth=str2double(char(get(handles.smoothpoints,'String')));
findingPeakModel=get (handles.findingPeaksModel,'value');
numOfpeaks=str2double(char(get (handles.numberOfPeaks,'String')));
FitWidth=round(str2double(char(get (handles.fitwidth,'String'))));
AmpThreshold=(str2double(char(get (handles.ampTH,'String'))))*max(peaky);
SlopeThreshold=round(str2double(char(get (handles.slopTH,'String'))));
if (get (handles.fixedSlope,'value'))
    slopeWhichIsFixed = round(str2double(get (handles.slope,'String')));
else
    slopeWhichIsFixed=[];
end
modelFit=get (handles.FittingFunction,'value');
bckmodel2=get (handles.bckmodel2,'value');
remMan=get(handles.remMan,'value');
ManListBox=get(handles.ManListBox,'String');
if (modelFit==5)
    set(handles.FittingFunction,'value',1);
%     % Update handles structure
     guidata(hObject,handles);
    [vStart,peakAt,peakAmp,indexPeaks,xL,xR,yL,yR,w,vEnd,yEnd,xpeaks]= Fittingone(handles,x,peaky,xpeaks,yraw,bckPar);
    xpeaks=peakAt;
    set(handles.remMan,'value',1);
    set(handles.FittingFunction,'value',5);
  %  set(handles.ManListBox,'String',num2str(peakAt));
 %   pause (0.1)
    modelFit=5;
%     % Update handles structure
     guidata(hObject,handles);
     
end

if ((findingPeakModel==5) & (remMan) & (~isempty(ManListBox)))
    if (length (str2num(ManListBox))== numOfpeaks)
        xpeaks=str2num(ManListBox);
        end
end


%axes(handles.axes1);



[peakAt,peakAmp,indexPeaks,xL,xR,yL,yR,w] =findingStartConditions (x,peaky,xpeaks,numOfpeaks,smooth,findingPeakModel,SlopeThreshold,AmpThreshold,FitWidth);
if (get(handles.updateMan,'value') & ~isempty(peakAt))
    set(handles.ManListBox,'String',num2str(peakAt));
end


% fitting a lorenzian
vStart=[];
numofpeakIn=length(peakAt);
if (~isempty(peakAt) && ~isempty(w))

    for i=1:numofpeakIn
        vStart=[vStart peakAmp(i) w(i) peakAt(i)]; %#ok<AGROW>
    end
end
vStart=abs(vStart);
if (bckmodel2<3)
    bckPar=bckPar(1:3);
end
if ((bckmodel2>2) & (length(bckPar)<4))
    bckPar=[bckPar 0];
end
if ((bckmodel2>3) & (length(bckPar)<5))
    bckPar=[bckPar(1:2)];
end
if ((bckmodel2>4) & (length(bckPar)<6))
    bckPar=[bckPar(1:2)];
end


vStart=[vStart bckPar];
vStart=real(vStart);

if (modelFit==5)

    ytofit=yraw;
else

    ytofit=peaky;
end
[vEnd,numofpeaks]=fittingPeaks (vStart,x,ytofit,handles,modelFit,bckmodel2,bckPar,slopeWhichIsFixed);
%if (modelFit==5)
%    modelFit=3;
%end
%bckPar(2)=0;
lenVend=length(vEnd);
% if (modelFit==5)
% 
%     vEnd2=vEnd;
% elseif (bckmodel2<3)
%     vEnd2=vEnd(1:lenVend-2);
% else
%     vEnd2=vEnd(1:lenVend-3);
% end
if ~(numofpeakIn==numofpeaks)
    beep
    disp ('problem go to fittingone.m num. peaks in ~= num. of peaks out');
end
%vEnd=abs(vEnd);
yEnd=fun(vEnd,x,modelFit,4,bckmodel2,bckPar.*0,numofpeaks);


   
