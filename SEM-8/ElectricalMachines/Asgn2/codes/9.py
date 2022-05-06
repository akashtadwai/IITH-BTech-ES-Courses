wi = 330
kva = int(18 * 1e3)
wu = int(8 * 1e3)
pf = 0.75
n = 92.93 / 100
f_load = wu / (kva * pf)
output = kva * pf * f_load
loss = output * (1 - n) / n
ans = (loss - wi) / (f_load ** 2)
print(ans)
