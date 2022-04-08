import t89py
import numpy as np
import os

X = np.arange(100,dtype = np.float64)
Y = np.arange(100,dtype = np.float64)
Z = np.arange(100,dtype = np.float64)
iopt = 2
ps = 10

Bx, By, Bz = t89py.t89_v(iopt, ps, X,Y,Z)
B = np.column_stack((Bx, By, Bz))

foutput = []
for x,y,z, b in zip(X,Y,Z, B):
    stream = os.popen(f'echo {x} {y} {z} {ps} {iopt} | ./t89')
    output = stream.read()
    output = output.split('\n')[1]
    output = output.split()
    output = np.array([float(i) for i in output])
    foutput.append(output)
    # diff = abs(b-output)
    # print(diff)
foutput = np.array(foutput)
close = np.isclose(B,foutput)
print(sum(close)==len(close))
# push to repo 
