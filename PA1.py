import itertools
import numpy as np


# returns mod 2 matrix
def mod_2(matrix):
    for idx, val in enumerate(matrix):
        for idx2, val2 in enumerate(val):
            matrix[idx][idx2] %= 2

    return matrix


r = int(input("Enter r:"))
n = 2 ** r - 1
k = n - r

print("n:", n)
print("k:", k)
print("r:", r)

# A: r x k matrix
A = []

# Identity matrices
I_r = np.identity(r, dtype=int)
I_k = np.identity(k, dtype=int)

pow_lst = []
for i in range(0, r):
    pow_lst.append(2 ** i)

# r bit binary numbers from 1 to n
for i in range(1, n + 1):
    if i not in pow_lst:
        A.append(list("{0:b}".format(i).zfill(r)))

# convert all elements to int
for idx, val in enumerate(A):
    A[idx] = list(map(int, A[idx]))

# transpose A
A_T = A
A = list(map(list, zip(*A)))

# H = [A|I]
H = np.column_stack((A, I_r))
print("\nH:")
print(H)

# G = [I|-A^T]
G = np.column_stack((I_k, A_T))
print("\nG:")
print(G)

# Generate all codewords
msg_lst = list(map(list, itertools.product([0, 1], repeat=k)))
print("\nValid Codewords: ")
for idx, val in enumerate(msg_lst):
    prod = mod_2(np.matmul(np.matrix(val), G))
    print(prod)

while True:
    print("\n1. Encode a message")
    print("2. Decode a codeword")
    ch = input("\nEnter choice: ")

    if ch == "1":
        msg = list(input("\nEnter %s bit message: " % k))

        if len(msg) != k:
            print("Invalid length. Enter %s bit message: " % k)
            continue

        msg = np.matrix(list(map(int, msg)))
        # msg x G
        prod = mod_2(np.matmul(msg, G))

        print("Encoded message: ", prod)

    elif ch == "2":
        code = list(input("\nEnter %s bit code: " % n))
        msg_bits = ''.join(code[:k])

        if len(code) != n:
            print("Invalid length. Enter %s bit code: " % n)
            continue

        code = np.matrix(list(map(int, code)))

        # check if valid code
        prod = mod_2(np.matmul(H, code.transpose()))

        print("Syndrome: ")
        print(prod)

        # check if syndrome is a 0 column vector
        if np.array_equal(prod, np.zeros((r, 1), dtype=int)):
            print("Valid Codeword!")
            print("Final Message: ", msg_bits)
        else:
            print("Error has occurred!")

    else:
        print("Invalid choice!")
