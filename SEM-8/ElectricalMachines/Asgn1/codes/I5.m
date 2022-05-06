f=40;
p=8;
R2=0.09;
X2=0.32;
Nfl=558;

Ns=120*f/p
Sfl=(Ns-Nfl)/Ns
Sm=R2/X2

%Tmax/Tfl
ratio=((Sm^2)+(Sfl^2))/(2*Sfl*Sm)