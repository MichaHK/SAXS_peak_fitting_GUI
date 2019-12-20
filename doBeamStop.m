function [x,y]=doBeamStop(handles,x,y)
%cut from beamstop
beamstopModel=get (handles.removeBeamStop,'value');
if (beamstopModel==1 )

    [tmp,maxyi]=max(y);


elseif  (beamstopModel==2 )
    %tmp=0;
    maxyi=1;
else
    maxyi=str2double(char(get (handles.beamStopNumber,'String')));
    %tmp=0;
end

lenx=length(x);
x=x(maxyi:lenx);
y=y(maxyi:lenx);

