"""
Checks if given code parameters satisfy the following bounds:
1. Singleton
2. Hamming
3. Plotkin
4. Griesmer
5. Gilbert Varshamov
"""

import math


def singleton_bound(n, k, d):
    print("Singleton Bound:", d <= n - k + 1)


def hamming_bound(n, k, d, q=2):
    t = math.floor((d - 1) / 2)
    sum = 0
    for i in range(0, t + 1):
        sum += nCr(n, i) * (q - 1) ** i
    print("Hamming Bound:", q ** k * sum <= q ** n)


def plotkin_bound(n, k, d):
    if d % 2 == 0 and 2 * d > n:
        print("Plotkin Bound:", 2 ** k <= 2 * math.floor(d / (2 * d - n)))
    elif d % 2 != 0 and 2 * d + 1 > n:
        print("Plotkin Bound:", 2 ** k <= 2 * math.floor(d + 1 / (2 * d + 1 - n)))
    else:
        print("Plotkin Bound: Not applicable")


def griesmer_bound(n, k, d):
    sum = 0
    for i in range(0, k):
        sum += math.ceil(d / 2 ** i)
    print("Griesmer Bound:", n >= sum)


def gilbert_varshamov_bound(n, k, d, q=2):
    sum = 0
    for i in range(0, d - 1):
        sum += nCr(n - 1, i) * (q - 1) ** i
    print("Gilbert-Varshamov Bound:", q ** k < q ** n / sum)


def nCr(n, r):
    f = math.factorial
    return f(n) // f(r) // f(n - r)


while True:
    param_list = input("\nEnter n,k,d: ").split(',')
    param_list = list(map(int, param_list))
    n = param_list[0]
    k = param_list[1]
    d = param_list[2]

    singleton_bound(n, k, d)
    hamming_bound(n, k, d)
    plotkin_bound(n, k, d)
    griesmer_bound(n, k, d)
    gilbert_varshamov_bound(n, k, d)
