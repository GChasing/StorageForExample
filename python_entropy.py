import numpy as np
import matplotlib.pyplot as plt
x = np.linspace(0,1,101)
y = -x*np.log2(x)-(1-x)*np.log2(1-x)
y[np.isnan(y)] = 0
plt.plot(x,y)
plt.show()