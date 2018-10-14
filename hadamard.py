import numpy


def chi(x):
    if x < 0:
        x = p - abs(x)

    if x == 0:
        return 0
    elif x in QR:
        return 1
    else:
        return -1


n = int(input("Enter n: "))
p = n - 1
print("p: ", p)

QR = []
QNR = []
for i in range(1, p):
    QR.append(i ** 2 % p)

QR = list(set(QR))
print("\nQuadratic residues of %s: " % p)
print(QR)

# create an empty pxp array
Q = numpy.zeros(shape=(p, p), dtype=int)
r = numpy.ones(shape=(1, n), dtype=int)
c = numpy.ones(shape=(p, 1), dtype=int)

for i in range(0, p):
    for j in range(0, p):
        if i == j:
            Q[i][j] = -1
        else:
            Q[i][j] = chi(j - i)

# add 1 vectors
Q = numpy.append(c, Q, axis=1)
Q = numpy.append(r, Q, axis=0)

print("\nH: ")
print(Q)
