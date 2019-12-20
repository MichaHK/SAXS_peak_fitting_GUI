function [filenames,directory_name,j]=readallchis(igorflag)
directory_name = uigetdir;
if (igorflag==1)
    fn=dir(strcat(directory_name,'\*.dat'));
elseif (igorflag==2)
    fn=dir(strcat(directory_name,'\*.chi'));
else
    fn=[dir(strcat(directory_name,'\*.chi'));dir(strcat(directory_name,'\*.dat'));dir(strcat(directory_name,'\*.fsi'))];
end
j=0;filenames={};
for i=1:length(fn);
    if ~(fn(i).isdir)
        j=j+1;
        filenames{j}=fn(i).name;
    end
end
cd (directory_name);


