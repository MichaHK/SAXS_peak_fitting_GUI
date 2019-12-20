function poi=plotingFigures (handles,num,x,y,str,holdit)

linlog1=get (handles.linlog1,'value');
linlog2=get (handles.linlog2,'value');
y(find(y<0))=eps;
if (num==1)
    axes(handles.axes1);
    if holdit
        hold on
    else
        hold off
    end
    if (linlog1==1)
        poi=loglog(x,y,str);
    elseif (linlog1==2)
        poi=semilogy (x,y,str);
     elseif (linlog1==3)
        poi=semilogx (x,y,str);
    else
        poi=plot (x,y,str);
    end
elseif (num==2)
    axes(handles.axes2);
    if holdit
        hold on
    else
        hold off
    end
    if (linlog2==1)
        poi=loglog(x,y,str);
    elseif (linlog2==2)
        poi=semilogy (x,y,str);
     elseif (linlog2==3)
        poi=semilogx (x,y,str);
    else
        poi=plot (x,y,str);
    end
end
    