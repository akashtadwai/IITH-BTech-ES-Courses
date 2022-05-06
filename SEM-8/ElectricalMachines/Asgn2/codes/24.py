il = 732
cl = 1125
fraction = 1 / 2
total_loss = il + (fraction ** 2) * cl
kvi = int(38 * 1e3)
input = kvi * fraction
ans = input / (input + total_loss)
print(ans * 100)
