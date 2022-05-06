r1 = 0.042
r2 = 0.026
v1 = 1250
v2 = 500
p = int(320 * 1e3)
factor = 4 / 7
K = v2 / v1
reff = r1 + r2 / K ** 2
ans = (p / v1) ** 2 * (factor ** 2) * reff
print(ans)
