import math

r = 1
x = 5
pf = 0.8
temp = math.sqrt(1 - pf ** 2)
ans = r * pf + x * temp
print(ans)
