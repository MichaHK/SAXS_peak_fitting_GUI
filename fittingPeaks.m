function [ParOut,numberOfpeaks]=fittingPeaks (initialguess,x,y,handles,model,bckmodel2,bckPar,slopeWhichIsFixed)
%bckPar
numOfiter=str2double(char(get(handles.numOfiter,'String')));

disp ('I am fitting');
op=optimset;
options = optimset(op,'display','final','MaxFunEvals',numOfiter,'TolFun',eps);

%lenv=length(initialguess);
lenInit=length(initialguess);
InitOriginal=initialguess;
[A,w,x0,y0,Abck,m,B]=ParfromV (initialguess,bckmodel2);
 if ~isempty (slopeWhichIsFixed)
     m=slopeWhichIsFixed;
 end
numberOfpeaks=length(A);
bckstartat=(numberOfpeaks*3)+1;
minx=min(x);
% ROI
if get(handles.useROI,'value')
    qminroi=max(str2double(char(get (handles.roiqmin,'String'))),min(x));
    qmaxroi=min(str2double(char(get (handles.roiqmax,'String'))),max(x));
    [xo,yo,indexqmin]=closetox(x,y,qminroi);
    [xo,yo,indexqmax]=closetox(x,y,qmaxroi);
    x=x(indexqmin:indexqmax);
    y=y(indexqmin:indexqmax);
end



% setting limits
maxy=max(y);
maxx=max(x);

%miniPar=zeros((numberOfpeaks+1)*3,1);
miniPar=zeros(numberOfpeaks*3+1,1);

%limit for base
miniPar(bckstartat)=min(0,y0); %#ok<NASGU>
maxiPar(bckstartat)=(10+abs(y0))*2;
%limit for bckground

miniPar(bckstartat+1)= Abck/10;  %amp
maxiPar(bckstartat+1)= Abck*10;  %amp
if (bckmodel2==1)
    if isempty (slopeWhichIsFixed)
    miniPar(bckstartat+2)= m*1.2;  %exp
    maxiPar(bckstartat+2)= m/1.2;  %exp
    else
        miniPar(bckstartat+2)= m-0.001;  %exp
        maxiPar(bckstartat+2)= m+0.001;  %exp  effectivly doesn't change
    end
elseif (bckmodel2<4)
    miniPar(bckstartat+2)= 0;  %K
    maxiPar(bckstartat+2)= max(m,10000);  %K
    if (bckmodel2==3)
        % if (B>0)
        miniPar(bckstartat+3)= 0;  %B
        maxiPar(bckstartat+3)= max(abs(B),10000);  %B
        %else
        %   miniPar(bckstartat+3)= min(B,-10000);  %B
        %   maxiPar(bckstartat+3)= 0;  %B
        %end

    end
end
%miniPar=miniPar';
%limit for peaks
%maxiPar(1:3:lenv)=0;
%A
maxiPar(1:3:numberOfpeaks*3)=A.*4;
miniPar(1:3:numberOfpeaks*3)=A./4;%%%%%%fix it for better limit %%%%%%%
%w
maxiPar(2:3:numberOfpeaks*3)=w.*20;
miniPar(2:3:numberOfpeaks*3)=w./20;

%x0
maxiPar(3:3:numberOfpeaks*3)=x0.*1.4;
miniPar(3:3:numberOfpeaks*3)=x0./1.4;


%maxiPar=maxiPar'; %#ok<NASGU>

if ((model==1) || (model==2))
    initialguess=initialguess(1:numberOfpeaks*3+1);
    miniPar=miniPar(1:numberOfpeaks*3+1);
    maxiPar=maxiPar(1:numberOfpeaks*3+1);
    if (bckmodel2<3)
        bckPar=[y0 0 0];
    elseif (bckmodel2<4)
        bckPar=[y0 0  0 0];
    else 
       bckPar=[y0 0]; 
    end
end
if ((model==3) || (model==4))
    initialguess=initialguess(1:numberOfpeaks*3);
    miniPar=miniPar(1:numberOfpeaks*3);
    maxiPar=maxiPar(1:numberOfpeaks*3);
    if (bckmodel2<3)
        bckPar=[0 0 0];
    elseif (bckmodel2<4)
        bckPar=[0 0  0 0];
    else
        bckPar=[0 0];
    end
end


% if (model==5)   
%     bckPar=[];
% end

fittingloglog=get (handles.fitdataloglog,'value');
if (fittingloglog<3)
    xtofit=log(x');
else
    xtofit=x';
end
if ((fittingloglog==1) || (fittingloglog==3))
    ytofit=log(abs(y')+eps);
else
    ytofit=y';
end


[sm1,sm2]=size(miniPar);
[sx1,sx2]=size(maxiPar);
if (sm1~=sx1)
    
    miniPar=miniPar';
end
% figure(4)
% clf
% 
% plot (xtofit,ytofit)
% hold on
% plot (xtofit,fun(initialguess,xtofit,model,fittingloglog,bckmodel2,bckPar,numberOfpeaks),'r');
% [bck,bckexp,bckPar]=calcbckfromfit (x,[initialguess bckPar],bckmodel2);
% disp (bckPar);


% if (bckmodel2>3)
%     t=miniPar;
%     miniPar=t(1:(bckstartat+length(bckPar)-1));
%     t=maxiPar;
%     maxiPar=t(1:(bckstartat+length(bckPar)-1));
% % end
f=find(miniPar>maxiPar);
if ~isempty(f)
    tmp=miniPar(f);
    miniPar(f)=maxiPar(f);
    maxiPar(f)=tmp;
end



[ParOut,resnorm,residual,exitflag,output] =  lsqcurvefit('fun',...
    initialguess,xtofit,ytofit,miniPar,maxiPar,options,model,fittingloglog,bckmodel2,bckPar,numberOfpeaks); %#ok<NASGU,NASGU>
% plot (xtofit,fun(ParOut,xtofit,model,fittingloglog,bckmodel2,bckPar,numberOfpeaks),'g');
%  hold off
% if ((model==3) || (model==4))
%     initialguess=[initialguess];
%     ParOut=[ParOut 0];
% end
% if (model==5)
%     bckPar=[];
% end
% [bck,bckexp,bckPar]=calcbckfromfit (x,[ParOut bckPar],bckmodel2);
% disp (bckPar);
% Ai=initialguess(1:3:lenv-3);
% wi=initialguess(2:3:lenv-3);
% x0i=initialguess(3:3:lenv-3);
% Af=ParOut(1:3:lenv-3);
% wf=ParOut(2:3:lenv-3);
% x0f=ParOut(3:3:lenv-3);


%
% for i=1:numberOfpeaks
%
%     %    vStart=[y0,A,w,x0];
%     fprintf('Start:  peak #:%d A=%f  w=%f  x0=%f\n',i,Ai(i),wi(i),x0i(i));
%     fprintf('End:  peak #:%d A=%f  w=%f  x0=%f\n',i,Af(i),wf(i),x0f(i));
%
% end
% fprintf('Start: y0 = %f\n',initialguess(lenv));
% fprintf('Start: y0 = %f\n',ParOut(lenv));

lenEnd=length(ParOut);
if (lenEnd<lenInit)
    ParOut(lenEnd+1:lenInit)=InitOriginal(lenEnd+1:lenInit);
end