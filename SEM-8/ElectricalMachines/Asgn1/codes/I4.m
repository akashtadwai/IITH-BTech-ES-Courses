f=45;
p=8;
R2=0.05;
X2=0.16;
Nfl=641.25;

Ns=120*f/p;
Sfl=(Ns-Nfl)/Ns;
Sm=R2/X2;

%Tst/Tfl
ratio=((Sm^2)+(Sfl^2))/(Sfl*(Sm^2+1))