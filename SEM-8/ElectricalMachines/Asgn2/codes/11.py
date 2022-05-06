import math
from para3 import *

pf = woc / (voc * ioc)
temp = math.sqrt(1 - (pf ** 2))
ans = voc / (ioc * temp)
print(ans)
