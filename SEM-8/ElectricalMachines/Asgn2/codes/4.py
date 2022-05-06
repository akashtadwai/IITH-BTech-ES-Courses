f = 41
hl = 170
el = 70
A = hl / f
B = el / (f ** 2)
f_new = 58
ans = A * f_new + B * (f_new ** 2)
print(ans)
