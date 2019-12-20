function y=powderLorenzianNum (q,A,Lii,Lp,q0,w,x)

%pi2=6.283185307179586; %2*pi
lp2=Lp^2;  %l_par^2
li2=Lii^2; %l_|| ^2
%q2=q.^2;
x2=x.^2;
lenq=length(q);
y=zeros(1,lenq);
for qi=1:lenq
    q1=q(qi);
    y(qi)=sum(w./(1+li2.*q1.^2.*x2+lp2.*(q1.*sqrt(1-x2)-q0).^2));
end
yAtPeak=sum(w./(1+li2.*q0.^2.*x2+lp2.*(q0.*sqrt(1-x2)-q0).^2));
y=(y./yAtPeak)*A;
return
