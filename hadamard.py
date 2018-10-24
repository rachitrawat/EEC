import math
import random

import numpy


def isPrime(n, k=11):
    if n == 2 or n == 3:
        return True
    elif n % 2 == 0 or n < 2:
        return False

    x = n - 1
    r = 0

    while x % 2 == 0:
        x = x // 2
        r += 1

    for i in range(1, k + 1):
        if not miller_rabin(n, x, r):
            return False

    return True


def miller_rabin(n, d, r):
    a = random.randint(2, n - 2)
    x = pow(a, d, n)

    if x == 1 or x == n - 1:
        return True

    for i in range(1, r):
        x = pow(x, 2, n)
        if x == n - 1:
            return True

    return False


def paley(n):
    def chi(x):
        if x < 0:
            x = p - abs(x)

        if x == 0:
            return 0
        elif x in QR:
            return 1
        else:
            return -1

    QR = []
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


def sylvester(n):
    pass


n = int(input("Enter n: "))
p = n - 1
if n == 1:
    print("\nH: ")
    print(numpy.matrix([[1]]))
elif n == 2:
    print(numpy.matrix([[1, 1], [1, -1]]))
elif math.ceil(math.log(n, 2)) == math.floor(math.log(n, 2)):
    print("%s is a power of 2" % n)
    print("Sylvester construction is possible")
# Paley construction
elif n % 4 == 0 and isPrime(n - 1):
    print("Paley construction is possible")
    paley(n)
elif n % 4 == 0:
    print("Hadamard matrix of order %s may exist!" % n)
else:
    print("Hadamard matrix of order %s does not exist!" % n)
