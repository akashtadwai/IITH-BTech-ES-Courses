import math

ro1 = 0.245
xo1 = 0.34
ro = 709
xo = 387
v1 = 480
v2 = 210
k = v1 / v2

# 17,20
ro_ = ro / (k ** 2)
xo_ = xo / (k ** 2)
po = (v2 ** 2) / (ro_)
i = math.sqrt(po / ro_)

# 18,19
ps = int(4.7 * 1e3)
is_ = ps / v1
zo1 = math.sqrt(ro1 ** 2 + xo1 ** 2)
vs = is_ * zo1
power = is_ ** 2 * ro1
