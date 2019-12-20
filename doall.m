function [FNN]=doall (handles,modelbck,readfilesFlag,fittingFlag,bckFlag,hObject)
global data matfilename
set(handles.ManListBox,'String','');
if (get (handles.fixedSlope,'value'))
    slopeWhichIsFixed = round(str2double(get (handles.slope,'String')));
else
    slopeWhichIsFixed=[];
end
igorques = questdlg('who did the chi plot','igor/fit 2d','igor','fit2d','both','igor');
if strcmp (igorques,'igor')
    igorflag=1;
elseif strcmp (igorques,'fit2d')
    igorflag=2;
else
    igorflag=3;
end
if readfilesFlag

    [filenames,directory_name,numberOffiles]=readallchis(igorflag);
else
    numberOffiles=data.numberOffiles;
    directory_name=data.directory_name;
    filenames=data.filenames;
end
startxi=0;endxi=0;
FittingFunction=get (handles.FittingFunction,'value');
findingPeakModel=get (handles.findingPeaksModel,'value');
xpeaks=[];
modelbck2_1=get(handles.bckmodel2,'value');
for i=1:numberOffiles
    if readfilesFlag
        disp(filenames{i});
        [x,y]=readchifile (filenames{i},igorflag);
        [x,y]=doBeamStop(handles,x,y);
    else
        disp (data.filenames{i});
        x=data.newxfull{i};
        y=data.newyfull{i};
    end

    if bckFlag
        
        [x1,y1,peaky1,bck1,startx1,endx1,mV,bckPar1]=dobkg (x,y,startxi,endxi,handles,modelbck,modelbck2_1,slopeWhichIsFixed);
        plotingFigures (handles,2,x1,peaky1,'-k*',false);
        axis tight
    else
        x1=data.newxfull{i};
        y1=data.newyfull{i};
        peaky1=data.peaky{i};
        bck1=data.bck{i};
        startx1=data.startx(i);
        endx1=data.endx(i);
        mV=data.m(i);
        bckPar1=data.bckPar(i);
        modelbck2_1=data.modelbck2(i);
        %        bckAmp1=data.bckAmp(i);
    end
    if fittingFlag
        [vStart1,tpeakAt,tpeakAmp,tindexPeaks,sxL,sxR,syL,syR,tw,vEnd1,yEnd1,xpeaks]= Fittingone(handles,x1,peaky1,xpeaks,y,bckPar1,hObject);
                                                                                     %Fittingone(handles,x,peaky,xpeaks,yraw,bckPar)
        modelFit=get (handles.FittingFunction,'value');
        %   get(handles.fitdataloglog,'value')
        if (modelFit==5)
            [bck1,mV,bckPar1]=calcbckfromfit (x,vEnd1,modelbck2_1);
            peaky1=y-bck1;
        end

    else
        vStart1=data.vStart{i};
        sxL=data.xL{i};
        sxR=data.xR{i};
        syL=data.yL{i};
        syR=data.yR{i};
        vEnd1=data.vEnd{i};
        yEnd1=data.yEnd{i};
        bckPar1=data.bckPar;

    end
    %     bckBase(i)=bckBase1;
    %     bckAmp(i)=bckAmp1;

    bckPar{i}=bckPar1;
    m(i)=mV;
    newxfull{i}=x1;
    newyfull{i}=y1;
    peaky{i}=peaky1;
    bck{i}=bck1;
    startx(i)=startx1;
    endx(i)=endx1;
    vStart{i}=vStart1;
    vEnd{i}=vEnd1;
    yEnd{i}=yEnd1;
    model(i)=FittingFunction;
    xL{i}=sxL;xR{i}=sxR;yL{i}=syL;yR{i}=syR;
    startxi=startx(i);endxi=endx(i);
    bckmodel2(i)=modelbck2_1;
    if readfilesFlag
        flag{i}='x'; %#ok<AGROW>
    else
        flag{i}=data.flag{i};
    end
end


refresh
[FN,PN]=uiputfile('*.mat','Saving results');
FNN=strcat (PN,'\',FN);
%save (FNN,'filenames','directory_name', 'newxfull','newyfull','peaky','bck','startx','endx','vStart','vEnd','yEnd','flag','numberOffiles','m','bckBase','bckAmp','model','xL','xR','yL','yR');
save (FNN,'filenames','directory_name', 'newxfull','newyfull','peaky','bck','startx','endx','vStart','vEnd','yEnd','flag','numberOffiles','m','bckPar','bckmodel2','model','xL','xR','yL','yR');

%fid = fopen(strrep(FNN,'.mat','.dat'), 'wt');
%fprintf(fid,'x0\t w\t x0NoFit\t wNoFit\t Slop\t Flag\t fileName\n');
%for i=1:numberOffiles
%    fprintf(fid, '%f \t%f\t %f \t %f\t %f\t %s\t %s\n',vEnd(i,4),vEnd(i,3),vStart(i,4),vStart(i,3),m(i),flag{i},filenames{i});
%end

%fclose(fid);
