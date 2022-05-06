na=1400
nab=360
nbc=640
nac=1000
v1=2000
Pac = 19000
rab = 800 

v2=v1*(nac/na)
v2ab = v2*(nab/nac)
P1=v2ab**2/rab 
ans = (P1+Pac) /v1
print(ans)
