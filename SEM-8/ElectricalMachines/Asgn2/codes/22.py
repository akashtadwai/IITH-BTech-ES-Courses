mva_new = int(136 * 1e6)
mva_old = int(5 * 1e7)
kv_old = int(1e4)
kv_new = int(21 * 1e3)
z_old = 0.4
ans = (z_old * (mva_new * (kv_old ** 2))) / (mva_old * (kv_new ** 2))
print(ans)
