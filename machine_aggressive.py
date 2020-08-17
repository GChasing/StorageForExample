import numpy
import sklearn.datasets as d
import matplotlib.pyplot as plt
reg_data = d.make_regression(100,1,1,1,1.0)
x,y = d.make_classification(100,2,2,0,0,2)
plt.subplot(121)
plt.plot(reg_data[0],reg_data[1])
plt.subplot(122)
plt.plot(x[:,0],x[:,1],marker=',')
plt.show()