function varargout = ReviewPeaks(varargin)
global data matfilename
% REVIEWPEAKS M-file for ReviewPeaks.fig
%      REVIEWPEAKS, by itself, creates a new REVIEWPEAKS or raises the existing
%      singleton*.
%
%      H = REVIEWPEAKS returns the handle to a new REVIEWPEAKS or the
%      handle to
%      the existing singleton*.
%
%      REVIEWPEAKS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REVIEWPEAKS.M with the given input arguments.
%
%      REVIEWPEAKS('Property','Value',...) creates a new REVIEWPEAKS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ReviewPeaks_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ReviewPeaks_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ReviewPeaks

% Last Modified by GUIDE v2.5 03-Sep-2013 10:51:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @ReviewPeaks_OpeningFcn, ...
    'gui_OutputFcn',  @ReviewPeaks_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before ReviewPeaks is made visible.
function ReviewPeaks_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ReviewPeaks (see VARARGIN)

% Choose default command line output for ReviewPeaks
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using ReviewPeaks.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes ReviewPeaks wait for user response (see UIRESUME)
 uiwait(handles.figure1);
 waitfor (handles.axes1,'FontAngle','Italic');
disp ('passout');

% --- Outputs from this function are returned to the command line.
function varargout = ReviewPeaks_OutputFcn(hObject, eventdata, handles)
global data matfilename
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

indexS=get (handles.index,'String');
index=round(str2num(indexS));
if (index>1)
    onlyset (handles,index-1);
else
    beep
end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
global data matfilename

% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[matfilename,pathname] = uigetfile('*.mat');
if ~(matfilename==0)
    cd (pathname);
    if ~isequal(matfilename, 0)
        loadAndset (handles,1);
    end
end

% --------------------------------------------------------------------

function loadAndset (handles,index)
global data matfilename

if (get(handles.autosave,'value'))
    data=load(matfilename);
    if ~isfield(data,'bckmodel2')
        disp ('converting from ver 2 to ver 3');
        beep;
        for i=1:data.numberOffiles
            data.bckmodel2(i)=1;
            data.bckPar{i}=[data.bckBase(i) data.bckAmp(i) data.m(i)];
            if (data.model(i)<5)
                data.vEnd{i}=[data.vEnd{i} data.bckPar{i}];
            end
        end
    end
end
onlyset(handles,index);


function onlyset (handles,index)
global data matfilename
set (handles.filename2,'String',matfilename);
set (handles.index,'String',num2str(index));
set (handles.numberOfFiles,'String',strcat('\',num2str(data.numberOffiles)));
indexPeak=round(str2double(get (handles.peaknumber,'String')));

vStart=data.vStart{index};
vEnd=data.vEnd{index};
bckmodel2=data.bckmodel2(index);

if (bckmodel2>3)
data.bckPar{index}=data.bckPar{index}(1:2);
end
bckPar=data.bckPar{index};


    
set (handles.bckmodel2,'value',bckmodel2);

[As,ws,x0s,y0s]=ParfromV (vStart,bckmodel2);
[A,w,x0,y0]=ParfromV (vEnd,bckmodel2);

if (isempty (x0))
    numOfPeaks=0;
    set (handles.peaknumber,'String','x');
    set (handles.x0,'String','x');
    set (handles.w,'String','x');
    set (handles.maxpeak,'String','x');
    set (handles.I37,'String','x');
else
    numOfPeaks=length(x0);
    for jj=1:numOfPeaks
        x0a{jj}=num2str(x0(jj));
        wa{jj}=num2str(w(jj));
        x0sa{jj}=num2str(x0s(jj));
        da{jj}=num2str(2*pi./x0(jj));
    end
    pnum=get (handles.peaknumber,'value');
    set (handles.x0,'String',x0a);
    set (handles.w,'String',wa);
    set (handles.maxpeak,'String',x0sa);
    set (handles.I37,'String',da);
    
end

 if ((indexPeak<=numOfPeaks) && (indexPeak>=1))
     pnum=indexPeak;
     set (handles.x0,'value',pnum);
     set (handles.w,'value',pnum);
     set (handles.maxpeak,'value',pnum);
     set (handles.I37,'value',pnum);
 else
     set (handles.peaknumber,'string','0');
 end
%     set (handles.x0,'String',num2str(x0(indexPeak)));
%     set (handles.w,'String',num2str(w(indexPeak)));
%     set (handles.maxpeak,'String',num2str(x0s(indexPeak)));
%     set (handles.I37,'String',num2str(2*pi./x0(indexPeak)));
% else
%    % set (handles.peaknumber,'String',num2str(numOfPeaks));
%     set (handles.peaknumber,'String','0');
%     set (handles.x0,'String',num2str(x0));
%     set (handles.w,'String',num2str(w));
%     set (handles.maxpeak,'String',num2str(x0s));
%     set (handles.I37,'String',num2str(2*pi./x0));
% end

set (handles.flag,'String',data.flag{index});
%set (handles.startbkg,'String',num2str(data.startx(index)));
%set (handles.endbkg,'String',num2str(data.endx(index)));
set (handles.filename,'String',data.filenames{index});
set (handles.slop,'String',num2str(data.bckPar{index}));
set (handles.FittingFunction,'value',round(data.model(index)));



plotingFigures (handles,1,data.newxfull{index},data.newyfull{index},'-k*',false);
plotingFigures (handles,1,data.newxfull{index},data.bck{index},'-r',true);

poi=plotingFigures (handles,1,data.newxfull{index},data.bck{index}+data.yEnd{index}','-g',true);
set (poi,'LineWidth',1.5);
axis tight
zoom on
%axes(handles.axes2);
%hold off
plotingFigures (handles,2,data.newxfull{index},data.peaky{index},'-k*',false);
poi=plotingFigures (handles,2,data.newxfull{index},data.yEnd{index},'-g',true);
set (poi,'LineWidth',2);
%plot (data.newxfull{index},data.peaky{index},'-k*',false);
%plot (data.newxfull{index},data.yEnd{index},'-g');

x=data.newxfull{index};
%y=data.peaky{index};
% if (data.model(index)>4)
%     modelf=3;
% else
modelf=data.model(index);
% end
if ((bckmodel2<3)&(length(data.bckPar{index})>4))
    data.bckPar{index}=data.bckPar{index}(1:3);
end
if((bckmodel2>3)&(length(data.bckPar{index})<4))
    data.bckPar{index}=[data.bckPar{index}];
elseif ((bckmodel2>2)&(length(data.bckPar{index})<4))
    data.bckPar{index}=[data.bckPar{index} 0];
end
    
bckPar2=data.bckPar{index}*0;%bckPar2(2)=0;
yStart=fun(data.vStart{index},x,modelf,4,bckmodel2,bckPar2,numOfPeaks);
plotingFigures (handles,2,x,yStart,'-m',true);
if (length (data.xL{index}) > 0)
    xL=data.xL{index};
    xR=data.xR{index};
    yR=data.yR{index};
    yL=data.yL{index};
    for i=1:length(xL)
        if (modelf<3)
            vn=[A(i) w(i) x0(i) y0];
        else
            vn=[A(i) w(i) x0(i)];
        end
        bckPar2=data.bckPar{index}*0;
        ys=fun(vn,x,modelf,4,bckmodel2,bckPar2,1);

        if ((indexPeak==i) || (indexPeak==0))
            plotingFigures (handles,2,x,ys,':g',true);
        end
        %    plotingFigures (handles,2,x,ys,'-',true);
     %   plotingFigures (handles,2,[xR(i) xL(i)],[yR(i) yL(i)],'-r',true);
        axes(handles.axes2)
        text(x0(i),A(i),strcat(' \leftarrow ',num2str(i)),'FontSize',18)

    end
    poi=plotingFigures (handles,2,x0,A,'^g',true);
    set(poi,'MarkerSize',12);
   % poi=plotingFigures (handles,2,xL,yL,'<r',true);
    %set(poi,'MarkerSize',12);
    %poi=plotingFigures (handles,2,xR,yR,'>r',true);
    %set(poi,'MarkerSize',12);
    axis tight
    zoom on
end







function PrintMenuItem_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
    ['Close ' get(handles.figure1,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
global data matfilename
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});



function startbkg_CreateFcn(hObject, eventdata, handles)
global data matfilename
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function endbkg_CreateFcn(hObject, eventdata, handles)
global data matfilename
% hObject    handle to endbkg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function flag_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of flag as text
%        str2double(get(hObject,'String')) returns contents of flag as a double


% --- Executes during object creation, after setting all properties.
data.flag{getindex(handles)}=strrep(get(handles.flag,'String'),' ','_');
if (get(handles.autosave,'value'))
 savetoMat
end

function savetoMat
global data matfilename

filenames=data.filenames;
m=data.m;
directory_name=data.directory_name;
newxfull=data.newxfull;
newyfull=data.newyfull;
peaky=data.peaky;
bck=data.bck;
startx=data.startx;
endx=data.endx;
vStart=data.vStart;
vEnd=data.vEnd;
yEnd=data.yEnd;
flag=data.flag;
numberOffiles=data.numberOffiles;
xL=data.xL;xR=data.xR;yL=data.yL;yR=data.yR;
model=data.model;
%bckBase=data.bckBase;
%bckAmp=data.bckAmp;
bckmodel2=data.bckmodel2;
bckPar=data.bckPar;
save (matfilename,'filenames','bckPar','bckmodel2','directory_name', 'newxfull','newyfull','peaky','bck','startx','endx','vStart','vEnd','yEnd','flag','numberOffiles','m','model','xL','xR','yL','yR');




function flag_CreateFcn(hObject, eventdata, handles)
global data matfilename
% hObject    handle to flag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function x0_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x0 as text
%        str2double(get(hObject,'String')) returns contents of x0 as a double


% --- Executes during object creation, after setting all properties.
function x0_CreateFcn(hObject, eventdata, handles)
global data matfilename
% hObject    handle to x0 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function w_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to w (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of w as text
%        str2double(get(hObject,'String')) returns contents of w as a double


% --- Executes during object creation, after setting all properties.
function w_CreateFcn(hObject, eventdata, handles)
global data matfilename
% hObject    handle to w (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function maxpeak_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to maxpeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxpeak as text
%        str2double(get(hObject,'String')) returns contents of maxpeak as a double


% --- Executes during object creation, after setting all properties.
function maxpeak_CreateFcn(hObject, eventdata, handles)
global data matfilename
% hObject    handle to maxpeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function I37_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to I37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of I37 as text
%        str2double(get(hObject,'String')) returns contents of I37 as a double


% --- Executes during object creation, after setting all properties.
function I37_CreateFcn(hObject, eventdata, handles)
global data matfilename
% hObject    handle to I37 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function filename_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename as text
%        str2double(get(hObject,'String')) returns contents of filename as a double


% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
global data matfilename
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

indexS=get (handles.index,'String');
index=round(str2num(indexS));

if (index<data.numberOffiles)
    onlyset (handles,index+1);
else
    beep
end


function index=getindex(handles)
indexS=get (handles.index,'String');
index=round(str2num(indexS));




function index_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of index as text
%        str2double(get(hObject,'String')) returns contents of index as a double


% --- Executes during object creation, after setting all properties.
indexS=get (handles.index,'String');
index=round(str2num(indexS));
if (index>=1)||(index<=data.numberOffiles)
    onlyset (handles,index);
else
    beep
end


function index_CreateFcn(hObject, eventdata, handles)
global data matfilename
% hObject    handle to index (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function doall_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to doall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

modelbck=get(handles.bckmodel,'value');
matfilename=doall(handles,modelbck,true,true,true,hObject);
loadAndset (handles,1);


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function origin_Callback(hObject, eventdata, handles)
global data matfilename
[matfilenameOrigin, pathname1] = uiputfile('*.txt','Save to orgin',strrep(matfilename,'.mat','.txt'));
cd (pathname1);
fid = fopen(matfilenameOrigin, 'wt');

maxPeaks=2;
for i=1:data.numberOffiles
    maxPeaks=max(maxPeaks,round((length(data.vStart{i})-3)/3));
end



for i=1:maxPeaks
    fprintf(fid,'x0_%i\t w_%i\t Amp_%i\t x0_%i_NoFit\t w_%i_NoFit\t Amp_NoFit_%i\t',i,i,i,i,i,i);
end
fprintf(fid,'Fit_model\t slop\t Flag\t fileName\n');

for i=1:data.numberOffiles
    [As,ww,x0s,y0,Abck,m,B]=ParfromV (data.vStart{i},data.bckmodel2(i));
   % vStart=data.vStart{i};
 %   numofpeaks=length(A);
    %As=vStart(1:3:lenv-3);
    %ws=vStart(2:3:lenv-3);
    %x0s=vStart(3:3:lenv-3);
%    vEnd=data.vEnd{i};
    [A,w,x0,y0,Abck,m,B]=ParfromV (data.vEnd{i},data.bckmodel2(i));
   % lenv=length(vEnd);
  %  A=vEnd(1:3:lenv-3);
  %  w=vEnd(2:3:lenv-3);
  %  x0=vEnd(3:3:lenv-3);
    


%     vStart=data.vStart{i};
%     lenv=length(vStart);
%     As=vStart(lenv-3:-3:1);
%     ws=vStart(lenv-3:-3:2);
%     x0s=vStart(lenv-3:-3:2);
% 
%     vEnd=data.vEnd{i};
%     lenv=length(vEnd);
%     A=vEnd(lenv-3:-3:1);
%     w=vEnd(lenv-3:-3:2);
%     x0=vEnd(lenv-3:-3:2);
%     data.filenames{i}
%     x0
%     [x0,SortI]=sort(x0,2,'descend');
    [A,SortI]=sort(A,2,'descend');
    %A=A(SortI);
    x0=x0(SortI);
    w=w(SortI);
    As=As(SortI);
    ws=ww(SortI);
    x0s=x0s(SortI);

    numOfpeaks=length(x0);
    
    addze=zeros(1,maxPeaks-numOfpeaks);
    x0=[x0 addze]; w=[w addze]; x0s=[x0s  addze]; ws=[ws  addze]; A=[A addze]; As=[As addze];
    for j=1:maxPeaks
        if (x0(j)==0)
            fprintf(fid,'x\t x\t x\t x\t x\t x\t');
        else
            fprintf(fid,'%f\t %f\t %f\t %f\t %f\t %f\t',x0(j),w(j),A(j),x0s(j),ws(j),As(j));
        end
    end
    fprintf(fid, '%i \t %f\t %s\t %s\n',data.model(i),data.m(i),data.flag{i},data.filenames{i});
end

fclose(fid);
disp ('done saving');
% hObject    handle to origin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Savemfile_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to Savemfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[matfilename, pathname1] = uiputfile('*.mat','Save as',matfilename);
cd (pathname1);
savetoMat

% --------------------------------------------------------------------
function One_file_Callback(hObject, eventdata, handles)

One_fle_ana(handles,true,true,hObject);



function One_fle_ana(handles,fittingFlag,BckFlag,hObject)
global data matfilename
% hObject    handle to One_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


i=getindex(handles);
%cd (data.directory_name);
%[x,y]=readchifile (data.filenames{i});
x=data.newxfull{i};
y=data.newyfull{i};
modelbck=get (handles.bckmodel,'value');
bckmodel2=get(handles.bckmodel2,'value');
modelf=get (handles.FittingFunction,'value');
if (get (handles.fixedSlope,'value'))
    slopeWhichIsFixed = round(str2double(get (handles.slope,'String')));
else
    slopeWhichIsFixed=[];
end
xpeaks=[];
if BckFlag
    [x1,y1,peaky1,bck1,startx1,endx1,m,bckPar1]=dobkg (x,y,0,0,handles,modelbck,bckmodel2,slopeWhichIsFixed);
    data.newxfull{i}=x1;
    data.bckPar{i}=(bckPar1);
    data.bckmodel2(i)=bckmodel2;
    data.newyfull{i}=y1;
    data.peaky{i}=peaky1;
    data.bck{i}=bck1;
    data.startx(i)=startx1;
    data.endx(i)=endx1;
    data.m(i)=m;
%    data.bckBase(i)=bckBase1;
%    data.bckAmp(i)=bckAmp1;
    plotingFigures (handles,2,data.newxfull{i},data.peaky{i},'-k*',false);
    axis tight
    
end
if fittingFlag
    [vStart1,tpeakAt,tpeakAmp,tindexPeaks,sxL,sxR,syL,syR,tw,vEnd1,yEnd1,xpeaks]= Fittingone(handles,data.newxfull{i},data.peaky{i},xpeaks,data.newyfull{i},data.bckPar{i},hObject);
    if (modelf==5)
            [data.bck{i},data.m(i),data.bckPar{i}]=calcbckfromfit (x,vEnd1,data.bckmodel2(i));
            data.peaky{i}=data.newyfull{i}-data.bck{i};
        end
%        fun
    data.vStart{i}=vStart1;
    data.vEnd{i}=vEnd1;
    data.yEnd{i}=yEnd1;
    data.xL{i}=sxL;data.xR{i}=sxR;data.yL{i}=syL;data.yR{i}=syR;
end
data.model(i)=modelf;
if (get(handles.autosave,'value'))
 savetoMat;
end
onlyset (handles,i);



% --- Executes on selection change in bckmodel.
function bckmodel_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to bckmodel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns bckmodel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bckmodel


% --- Executes during object creation, after setting all properties.
function bckmodel_CreateFcn(hObject, eventdata, handles)
global data matfilename
% hObject    handle to bckmodel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in zoom1.
function zoom1_Callback(hObject, eventdata, handles)
% hObject    handle to zoom1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data matfilename
axes(handles.axes1);
legend ('data','backgraound','fit')
zoom on

% --- Executes on button press in zoom2.
function zoom2_Callback(hObject, eventdata, handles)
% hObject    handle to zoom2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data matfilename
axes(handles.axes2);
zoom on



% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data matfilename
directory_name = uigetdir ('','Select dirctory to save the new files');


for index=1:data.numberOffiles
    fid1=fopen (strcat(directory_name,'\d',data.filenames{index}),'w');
    fprintf (fid1,'q(1/A)\t I(a.u.)\t bck(a.u.)\t Fit(a.u.)\n');
    x=data.newxfull{index};
    y1=data.newyfull{index};
    y2=data.bck{index};
    y3=y2+data.yEnd{index}';
    for j=1:length(x);
        fprintf (fid1,'%f\t %f\t %f\t %f\n',x(j),y1(j),y2(j),y3(j));
    end
    fclose (fid1);

%     fid2=fopen (strcat(directory_name,'\p',data.filenames{index}),'w');
%     fprintf (fid2,'q(1/A)\t I(a.u.)\t Inorm(a.u.)\t Fit1(a.u.)\t Fit2(a.u.)\n');
%     x=data.newxfull{index};
%     if (data.model(index)>4)
%         modelf=3;
%     else
%         modelf=data.model(index);
%     end
%     y2=fun(data.vStart{index},x,modelf,4);
%     y1=data.peaky{index};
%     y1norm=y1./max(y1);
%     y3=data.yEnd{index};
%     x=x./10;
%     for j=1:length(x);
%         fprintf (fid2,'%f\t %f\t %f\t %f\t %f\n',x(j),y1(j),y1norm(j),y2(j),y3(j));
%     end
%     fclose (fid2);
end

% --------------------------------------------------------------------
function combine_Callback(hObject, eventdata, handles)
% hObject    handle to combine (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global data matfilename
[matfilename2,pathname2] = uigetfile('*.mat');
cd (pathname2);
data2=load(matfilename2);

data.filenames=[data.filenames data2.filenames];
data.m=[data.m data2.m];
%data.directory_name=data.directory_name;
data.newxfull=[data.newxfull data2.newxfull];
data.newyfull=[data.newyfull data2.newyfull];
data.peaky=[data.peaky data2.peaky];
data.bck=[data.bck data2.bck];
data.startx=[data.startx data2.startx];
data.endx=[data.endx data2.endx];
data.vStart=[data.vStart  data2.vStart];
data.vEnd=[data.vEnd data2.vEnd];
data.yEnd=[data.yEnd data2.yEnd];
data.flag=[data.flag data2.flag];
data.numberOffiles=data.numberOffiles+data2.numberOffiles;
data.model=[data.model data2.model];
data.xL=[data.xL data2.xL];
data.xR=[data.xR data2.xR];
data.yL=[data.yL data2.yL];
data.yR=[data.yR data2.yR];
%data.bckBase=[data.bckBase data2.bckBase];
%data.bckAmp=[data.bckAmp data2.bckAmp];
data.bckmodel2=[data.bckmodel2 data2.bckmodel2];
data.bckPar=[data.bckPar data2.bckPar];

%%sorting by filename

[data.filenames,ind]=sort(data.filenames);
data.m=data.m(ind);
%data.bckBase=data.bckBase(ind);
data.newxfull=data.newxfull(ind);
data.newyfull=data.newyfull(ind);
data.peaky=data.peaky(ind);
data.bck=data.bck(ind);
data.bckPar=data.bckPar{ind};
data.bckmodel2=data.bckmodel2(ind);

data.startx=data.startx(ind);
data.endx=data.endx(ind);
data.vStart=data.vStart{ind};
data.vEnd=data.vEnd{ind};
data.yEnd=data.yEnd(ind);
data.flag=data.flag(ind);
data.xL=data.xL{ind};
data.xR=data.xR{ind};
data.yL=data.yL{ind};
data.yR=data.yR{ind};
data.model=data.model(ind);
Savemfile_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function find_Callback(hObject, eventdata, handles)
% hObject    handle to find (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data matfilename

answer=inputdlg({'find filename:'},'find',1,{'070'});
findr=strfind (data.filenames,char(answer));
j=0;
for i=1:data.numberOffiles
    if ~isempty(findr{i})
        j=j+1;
        searchr{j}=data.filenames{i};
        indexsearch{j}=i;
    end
end
if (j>0)
    [s,v] = listdlg('PromptString','Select a file:',...
        'SelectionMode','single',...
        'ListString',searchr);
    if (v>0)
        onlyset (handles,indexsearch{s});
    end
end





% --------------------------------------------------------------------
function deleteFigure_Callback(hObject, eventdata, handles)
% hObject    handle to deleteFigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data matfilename

i=getindex(handles);
button = questdlg('Are you sure you want to delete this figure?','Delete','Yes','No','No');
if strcmp(button,'Yes')
    deletingFigures (i);
    data=load(matfilename);
    if (data.numberOffiles<i)

        onlyset (handles,data.numberOffiles);
    else
        onlyset (handles,i);
    end
end

function deletingFigures (indexes)
global data matfilename
data2=load(matfilename);
%data2=data;
data=[];
jmax=length(indexes);
ji=1;
newindex=0;
nof=data2.numberOffiles;
for i=1:nof
    if (indexes(ji)==i)
        if (ji<jmax)
            ji=ji+1;
        end

    else
        newindex=newindex+1;
        data.filenames{newindex}=data2.filenames{i};
        data.m(newindex)=data2.m(i);
        data.newxfull{newindex}=data2.newxfull{i};
        data.newyfull{newindex}=data2.newyfull{i};
        data.peaky{newindex}=data2.peaky{i};
        data.bck{newindex}=data2.bck{i};
%         data.bckBase(newindex)=data2.bckBase(newindex);
%         data.bckAmp(newindex)=data2.bckAmp(newindex);
        data.bckmodel2(newindex)=data2.bckmodel2(i);
        data.bckPar{newindex}=data2.bckPar{i};
        data.startx(newindex)=data2.startx(i);
        data.endx(newindex)=data2.endx(i);
        data.vStart{newindex}=data2.vStart{i};
        data.vEnd{newindex}=data2.vEnd{i};
        data.yEnd{newindex}=data2.yEnd{i};
        data.flag{newindex}=data2.flag{i};
        data.model(newindex)=data2.model(i);
        data.xL{newindex}=data2.xL{i};
        data.xR{newindex}=data2.xR{i};
        data.yL{newindex}=data2.yL{i};
        data.yR{newindex}=data2.yR{i};

        %   data.numberOffiles=data2.numberOffiles-1; %deal with index=numberOf, and index=1 and save
    end

end
data.numberOffiles=data2.numberOffiles-ji;
data.directory_name=data2.directory_name;
savetoMat


% --------------------------------------------------------------------

function select_Callback(hObject, eventdata, handles) %#ok<DEFNU>
% hObject    handle to select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data matfilename


%index=getindex(handles);
out=getrect(handles.axes1);
xi=out(1:2:3);xi(2)=xi(2)+xi(1);
for i=1:data.numberOffiles
    [xo,yo,indexes]=closetox(data.newxfull{i},data.newxfull{i},xi);
    data.newxfull{i}=data.newxfull{i}(indexes(1):indexes(2));
    data.newyfull{i}=data.newyfull{i}(indexes(1):indexes(2));
end
    
    

modelbck=get(handles.bckmodel,'value');
matfilename=doall(handles,modelbck,false,true,true);
loadAndset (handles,1);



% --------------------------------------------------------------------
function deleteMany_Callback(hObject, eventdata, handles)
% hObject    handle to deleteMany (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data matfilename

i=getindex(handles);

[s,v] = listdlg('PromptString','Select a file:',...
    'SelectionMode','param',...
    'ListString',data.filenames);
if (v>0)
    button = questdlg('Are you sure you want to delete these figures?','Delete','Yes','No','No');
    if strcmp(button,'Yes')
        deletingFigures (s);
        data=load(matfilename);

        if (data.numberOffiles<i)
            onlyset (handles,data.numberOffiles);
        else
            onlyset (handles,i);
        end
    end
end





% --- Executes on selection change in removeBeamStop.
function removeBeamStop_Callback(hObject, eventdata, handles)
% hObject    handle to removeBeamStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns removeBeamStop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from removeBeamStop
beamstopModel=get (handles.removeBeamStop,'value');
if (beamstopModel==3)
    set (handles.beamStopNumber,'visible','on');
else
    set (handles.beamStopNumber,'visible','off');

end


function beamStopNumber_Callback(hObject, eventdata, handles)
% hObject    handle to beamStopNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beamStopNumber as text
%        str2double(get(hObject,'String')) returns contents of beamStopNumber as a double


% --- Executes during object creation, after setting all properties.
function beamStopNumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beamStopNumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in findingPeaksModel.
function findingPeaksModel_Callback(hObject, eventdata, handles)
% hObject    handle to findingPeaksModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns findingPeaksModel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from findingPeaksModel


% --- Executes during object creation, after setting all properties.
function findingPeaksModel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to findingPeaksModel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numberOfPeaks_Callback(hObject, eventdata, handles)
% hObject    handle to numberOfPeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberOfPeaks as text
%        str2double(get(hObject,'String')) returns contents of numberOfPeaks as a double


% --- Executes during object creation, after setting all properties.
function numberOfPeaks_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberOfPeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in FittingFunction.
function FittingFunction_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to FittingFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns FittingFunction contents as cell array
%        contents{get(hObject,'Value')} returns selected item from FittingFunction
i=getindex(handles);
modelf=get (handles.FittingFunction,'value');
data.model(i)=modelf;
if (get(handles.autosave,'value'))
savetoMat;
end
%additionalFitting_Callback(hObject, eventdata, handles);




% --- Executes during object creation, after setting all properties.
function FittingFunction_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FittingFunction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function smoothpoints_Callback(hObject, eventdata, handles)
% hObject    handle to smoothpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smoothpoints as text
%        str2double(get(hObject,'String')) returns contents of smoothpoints as a double


% --- Executes during object creation, after setting all properties.
function smoothpoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothpoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in linlog1.
function linlog1_Callback(hObject, eventdata, handles)
% hObject    handle to linlog1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns linlog1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from linlog1
i=getindex(handles);
onlyset (handles,i);
% --- Executes during object creation, after setting all properties.
function linlog1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linlog1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in linlog2.
function linlog2_Callback(hObject, eventdata, handles)
% hObject    handle to linlog2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns linlog2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from linlog2

i=getindex(handles);
onlyset (handles,i);
% --- Executes during object creation, after setting all properties.
function linlog2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linlog2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numOfiter_Callback(hObject, eventdata, handles)
% hObject    handle to numOfiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numOfiter as text
%        str2double(get(hObject,'String')) returns contents of numOfiter as a double


% --- Executes during object creation, after setting all properties.
function numOfiter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numOfiter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function additionalfitting_func(handles,i,bckmodel2)
global data matfilename

if (data.model(i)>4)

    ytofit=data.newyfull{i};
else

    ytofit=data.peaky{i};
end
data.vStart{i}=data.vEnd{i};
if (get (handles.fixedSlope,'value'))
    slopeWhichIsFixed = round(str2double(get (handles.slope,'String')));
else
    slopeWhichIsFixed=[];
end
[data.vEnd{i},numOfPeaks]=fittingPeaks (data.vEnd{i},data.newxfull{i},ytofit,handles,data.model(i),bckmodel2,data.bckPar{i},slopeWhichIsFixed);
if (data.model(i)>4)
    [data.bck{i},data.m(i),data.bckPar{i}]=calcbckfromfit (data.newxfull{i},data.vEnd{i},bckmodel2);
    data.peaky{i}=data.newyfull{i}-data.bck{i};
end
% if (data.model(i)>4)
%     modelFit=3;
% else
%     modelFit=data.model(i);
% end
modelFit=data.model(i);
bckPar2=data.bckPar{i}*0;
%bckPar2(2)=0;
data.yEnd{i}=fun(data.vEnd{i},data.newxfull{i},modelFit,4,bckmodel2,bckPar2,numOfPeaks);
if (get(handles.autosave,'value'))
    savetoMat;
end
onlyset (handles,i);


% --- Executes on button press in additionalFitting.
function additionalFitting_Callback(hObject, eventdata, handles)
% hObject    handle to additionalFitting (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data matfilename
bckmodel2=get(handles.bckmodel2,'value');
i=getindex(handles);
% %just for now
% if (data.model(i)==1)
%     data.model(find(data.model==1))=5;
% %    data.model(i)=5;
%     set(handles.FittingFunction,'value',5);
% %     % Update handles structure
%      guidata(hObject,handles);
% end
additionalfitting_func(handles,i,bckmodel2);




function peaknumber_Callback(hObject, eventdata, handles)
% hObject    handle to peaknumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of peaknumber as text
%        str2double(get(hObject,'String')) returns contents of peaknumber as a double
%global data matfilename

i=getindex(handles);
onlyset (handles,i);

% --- Executes during object creation, after setting all properties.
function peaknumber_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peaknumber (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in gopeak.
function gopeak_Callback(hObject, eventdata, handles)
global data
% hObject    handle to gopeak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index=getindex(handles);
axes(handles.axes2)
indexPeak=round(str2double(get (handles.peaknumber,'String')));

vStart=data.vStart{index};
vEnd=data.vEnd{index};
[Avs,wvs,x0vs,y0e,Abck,m,B]=ParfromV (vEnd,data.bckmodel2(i))
%lenv=length(vStart);
As=Avs(indexPeak);
ws=wvs(indexPeak);
x0s=x0vs(indexPeak);
%y0e=vEnd(lenv);

[Av,wv,x0v,y0,Abck,m,B]=ParfromV (vEnd,data.bckmodel2(i))
%lenv=length(vEnd);
A=Av(indexPeak);
w=wv(indexPeak);
x0=x0v(indexPeak);

xs=min(x0-2*w,x0s-2*ws);
xe=max(x0+2*w,x0s+2*ws);
ye=max(As,A)*1.2+y0;
ys=min(y0,y0e);
axis ([xs xe ys ye]);


% --------------------------------------------------------------------
function doallNoLoad_Callback(hObject, eventdata, handles)
global data matfilename
% hObject    handle to doallNoLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
modelbck=get(handles.bckmodel,'value');
matfilename=doall(handles,modelbck,false,true,true,hObject);
loadAndset (handles,1);


% --------------------------------------------------------------------
function doallbackground_Callback(hObject, eventdata, handles)
% hObject    handle to doallbackground (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data matfilename
modelbck=get(handles.bckmodel,'value');
matfilename=doall(handles,modelbck,false,false,true);
loadAndset (handles,1);

%load,fittingFlag,bckFlag

% --------------------------------------------------------------------
function doallPeaks_Callback(hObject, eventdata, handles)
% hObject    handle to doallPeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data matfilename
modelbck=get(handles.bckmodel,'value');
matfilename=doall(handles,modelbck,false,true,false);
loadAndset (handles,1);

%load,fittingFlag,bckFlag
% --------------------------------------------------------------------
function doonePeaks_Callback(hObject, eventdata, handles)
% hObject    handle to doonePeaks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data matfilename
One_fle_ana(handles,true,false,hObject)

% --------------------------------------------------------------------
function dooneBck_Callback(hObject, eventdata, handles)
% hObject    handle to dooneBck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data matfilename
One_fle_ana(handles,false,true,hObject)





function slopTH_Callback(hObject, eventdata, handles)
% hObject    handle to slopTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slopTH as text
%        str2double(get(hObject,'String')) returns contents of slopTH as a double


% --- Executes during object creation, after setting all properties.
function slopTH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slopTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ampTH_Callback(hObject, eventdata, handles)
% hObject    handle to ampTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ampTH as text
%        str2double(get(hObject,'String')) returns contents of ampTH as a double


% --- Executes during object creation, after setting all properties.
function ampTH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ampTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fitwidth_Callback(hObject, eventdata, handles)
% hObject    handle to fitwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fitwidth as text
%        str2double(get(hObject,'String')) returns contents of fitwidth as a double


% --- Executes during object creation, after setting all properties.
function fitwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fitwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------




% --------------------------------------------------------------------
function edit_Callback(hObject, eventdata, handles)
% hObject    handle to edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function basepoints_Callback(hObject, eventdata, handles)
% hObject    handle to basepoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of basepoints as text
%        str2double(get(hObject,'String')) returns contents of basepoints as a double


% --- Executes during object creation, after setting all properties.
function basepoints_CreateFcn(hObject, eventdata, handles)
% hObject    handle to basepoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in autosave.
function autosave_Callback(hObject, eventdata, handles)
% hObject    handle to autosave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of autosave




% --- Executes on selection change in fitdataloglog.
function fitdataloglog_Callback(hObject, eventdata, handles)
% hObject    handle to fitdataloglog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns fitdataloglog contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fitdataloglog


% --- Executes during object creation, after setting all properties.
function fitdataloglog_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fitdataloglog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setROI.
function setROI_Callback(hObject, eventdata, handles)
% hObject    handle to setROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes (handles.axes2);
zoom off
pause (0.1);
refresh
disp('roi');
%out=getrect(handles.axes2);
out=getrect;
xi=out(1:2:3);xi(2)=xi(2)+xi(1);
set(handles.roiqmin,'string',num2str(min(xi)));
set(handles.roiqmax,'string',num2str(max(xi)));
zoom on



function roiqmin_Callback(hObject, eventdata, handles)
% hObject    handle to roiqmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roiqmin as text
%        str2double(get(hObject,'String')) returns contents of roiqmin as a double


% --- Executes during object creation, after setting all properties.
function roiqmin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roiqmin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function roiqmax_Callback(hObject, eventdata, handles)
% hObject    handle to roiqmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of roiqmax as text
%        str2double(get(hObject,'String')) returns contents of roiqmax as a double


% --- Executes during object creation, after setting all properties.
function roiqmax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to roiqmax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in useROI.
function useROI_Callback(hObject, eventdata, handles)
% hObject    handle to useROI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useROI




% --- Executes on button press in bckmodel2.
function bckmodel2_Callback(hObject, eventdata, handles)
% hObject    handle to bckmodel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% disp (get(handles.bckmodel2,'value'))
% Hint: get(hObject,'Value') returns toggle state of bckmodel2

function exchangeBCKfunc (handles,index)
global data matfilename

%%need to read vEnd of onld - find where is the bckPar starts (if any - if not need to change when changeing from ver2 to ver3)
%then after we changed the bck - need to update just this part of vEnd with
%the new bckPar detail and then send it to additionalfitting
%[A,w,x0,y0,Abck,m,B]=ParfromV (data.vEnd{index},data.bckmodel2(index));
lenoldbck=length(data.bckPar{index});
lenoldvEnd=length(data.vEnd{index});
oldvEnd=data.vEnd{index};
oldvEnd=oldvEnd(1:lenoldvEnd-lenoldbck);
bckmodel2=get (handles.bckmodel2,'value');
if (bckmodel2>1)
    data.bckmodel2(index)=bckmodel2;
    [data.bck{index},data.bckPar{index}]=convertBck (data.newxfull{index},data.newyfull{index},data.bck{index},data.bckPar{index},bckmodel2);
    %[ParOut,numberOfpeaks]=fittingPeaks (initialguess,x,y,handles,model,bckmodel2,bckPar);
    data.peaky{index}=data.newyfull{index}-data.bck{index};
    data.vEnd{index}=[oldvEnd data.bckPar{index}];
    additionalfitting_func(handles,index,bckmodel2);
else
    disp ('can not change to this model -- please choose a different model for bckground');
end
% --------------------------------------------------------------------
function exchangeBCKone_Callback(hObject, eventdata, handles)
% hObject    handle to exchangeBCKone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data matfilename
indexS=get (handles.index,'String');
index=round(str2num(indexS));
exchangeBCKfunc (handles,index);
savetoMat
function exchangebckAll_Callback(hObject, eventdata, handles)
% hObject    handle to exchangebckAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global data matfilename
Savemfile_Callback(hObject, eventdata, handles)
for i=1:data.numberOffiles
    exchangeBCKfunc (handles,i);
end
savetoMat


% --- Executes on button press in remMan.
function remMan_Callback(hObject, eventdata, handles)
% hObject    handle to remMan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of remMan


% --- Executes on selection change in ManListBox.
function ManListBox_Callback(hObject, eventdata, handles)
% hObject    handle to ManListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ManListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ManListBox


% --- Executes during object creation, after setting all properties.
function ManListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ManListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updateMan.
function updateMan_Callback(hObject, eventdata, handles)
% hObject    handle to updateMan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of updateMan




% --- Executes on button press in fixedSlope.
function fixedSlope_Callback(hObject, eventdata, handles)
% hObject    handle to fixedSlope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fixedSlope



function slope_Callback(hObject, eventdata, handles)
% hObject    handle to slope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of slope as text
%        str2double(get(hObject,'String')) returns contents of slope as a double


% --- Executes during object creation, after setting all properties.
function slope_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
