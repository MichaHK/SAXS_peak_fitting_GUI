function y=powderLorenzian (q,A,Lii,Lp,q0)
lp2=Lp^2;  %l_par^2
li2=Lii^2; %l_|| ^2
q2=q.^2;
pi2=6.283185307179586; %2*pi
apb=2*q2.*(lp2.*(1+q0./q)-li2); %2a+b
b=2*lp2*q*q0;
eta=4*q2.*(lp2-li2).*(1+li2*q2-lp2*q0^2)-b.^2;
sqeta=sqrt(abs(eta));
[t,eta0]=find(eta==0);
[t,etabig]=find(eta>0);
[t,etasmall]=find(eta<0);
y(eta0)=2*((1./b(eta0))-(1./apb(eta0)));
y(etabig)=sqeta(etabig).*(atan(apb(etabig)./sqeta(etabig))-atan(b(etabig)./sqeta(etabig)));
y(etasmall)=sqeta(etasmall).*(log((apb(etasmall)-sqeta(etasmall))./(apb(etasmall)+sqeta(etasmall)))-log((b(etasmall)-sqeta(etasmall))./(b(etasmall)+sqeta(etasmall))));
y=y*pi2*A;
return
    
    

