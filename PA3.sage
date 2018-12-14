r = int(input("Enter r: "))
n = pow(2,r)-1
k = n-2*r
d = 5

print("n:{} f:{} d:{} r:{}".format(n, k, d, r))

K.<a> = GF(2^r, name='a')
print(K)
print "Modulus:", K.modulus()
m1=a.minpoly('x')
m3=(a^3).minpoly('x')
print "M1(x):", m1
print "M3(x):", m3
gx = m1 * m3
print "g(x):", gx

import numpy as np

G = np.zeros(shape=(k,n))
H = np.zeros(shape=(n-k,n))

for i in range(0,k):
	z=0
	for j in range(i,n):
		G[i][j]=gx.list()[z]
		z+=1
		if z == len(gx.list()):
			break


f(x)=x^n+1
hx= f.maxima_methods().divide(gx)[0].list()
hx = [item.pyobject() % 2 for item in hx]

for i in range(0,n-k):
	z=0
	for j in range(n-1-i, -1, -1):
		H[i][j]=hx[z]
		z+=1
		if z == len(hx):
			break

print "\nG:", G
print "\nH1:", H

H2 = []
for i in range(0, 2):
	tmp = []
	for j in range(0, n):
		if i == 0:
			tmp.append(a^j)
		else:
			tmp.append((a^j)^3)
	H2.append(tmp)

import pprint
print("\nH2: ")
pprint.pprint(H2)


import itertools

# returns mod 2 matrix
def mod_2(matrix):
    for idx, val in enumerate(matrix):
        for idx2, val2 in enumerate(val):
            matrix[idx][idx2] %= 2

    return matrix

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

    if ch == 1:
        msg = list(raw_input("\nEnter %s bit message: " % k))

        if len(msg) != k:
            print("Invalid length. Enter %s bit message: " % k)
            continue

        msg = np.matrix(list(map(int, msg)))
        # msg x G
        prod = mod_2(np.matmul(msg, G))

        print "Encoded message: ", prod 

    elif ch == 2:
        code = list(raw_input("\nEnter %s bit code: " % n))
        code_orig = code
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
            err_column_no = (np.where((H == prod).all(0))[1][0])
            print("Error has occurred in the %s bit!" % str(err_column_no + 1))
            code_orig[err_column_no] = str((int(code_orig[err_column_no]) + 1) % 2)
            print("Decoded codeword: ", ''.join(code_orig))
            print("Final Message: ", ''.join(code_orig[:k]))

    else:
        print("Invalid choice!")


