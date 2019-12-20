function [x,y]=readchifile (filename,igorflag)
ta=readtext (filename,'[\t ,]', '', '"', 'numeric-empty2zero');
try
if length (ta) >0
ft=find (ta(:,2)>0);
len=length(ta(:,2));
lenf=length(filename);
ext=filename(lenf-3:lenf);
if ((igorflag==1) || strcmp(ext,'.dat') || strcmp(ext,'.fsi'))
    if strcmp(ext,'.fsi')
        ta=load(filename,'-ascii');  %added 11/20/08
        ft=find (ta(:,2)>0); %added 11/20/08
        len=length(ta(:,2));%added 11/20/08
    end
    x=ta(ft:len,1); y=ta(ft:len,2)+10;
elseif ((igorflag==2) || strcmp(ext,'.chi'))
    x=ta(ft:len,2)/10; y=ta(ft:len,4); %(so all will be in angstrum and not in nm)
end
else
    x=[0.1 1];y=[0.1 1];
end
%removeing zeros from the data
ind=find(y>eps);
y=y(ind);x=x(ind);
catch
    x=[];y=[];
end