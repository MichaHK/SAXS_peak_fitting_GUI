function [xo,yo,index]=closetox(x,y,gx)
xo=[];yo=[];index=[];
for i=1:length (gx)

    dif=abs(x-gx(i));
    [mi,indext]=min(dif);
    index=[index indext]; %#ok<AGROW>
end
xo=x(index);yo=y(index);
