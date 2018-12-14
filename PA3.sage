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
# H = np.zeros(shape=(n-k,n))

for i in range(0,k):
	z=0
	for j in range(i,n):
		G[i][j]=gx.list()[z]
		z+=1
		if z == len(gx.list()):
			break


# f(x)=x^n+1
# hx= f.maxima_methods().divide(gx)[0].list()
# hx = [item.pyobject() % 2 for item in hx]

# for i in range(0,n-k):
# 	z=0
# 	for j in range(n-1-i, -1, -1):
# 		H[i][j]=hx[z]
# 		z+=1
# 		if z == len(hx):
# 			break

print "\nG:", G

H = []
for i in range(0, 2):
	tmp = []
	for j in range(0, n):
		if i == 0:
			tmp.append(a^j)
		else:
			tmp.append((a^j)^3)
	H.append(tmp)

import pprint
print("\nH: ")
pprint.pprint(H)


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
            print("Invalid length!")
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
            print("Invalid length!")
            continue

        code = list(map(int, code))

        z1=0
        z2=0
        for idx, val in enumerate(code):
        	if val == 1:
        		z1 += H[0][idx]
        		z2 += H[1][idx]

        print "z1: ",z1
        print "z2: ",z2

        # check if syndrome is a 0 column vector
        if z1 == z2 == 0:
            print "No error has occured!" 
            print "Final Message: ", msg_bits
        elif z1 != 0 and z2 == z1^3:
        	pos = H[0].index(z1)
        	print "1 error has occurred at position {}".format(pos+1)
           	code_orig[pos] = str((int(code_orig[pos]) + 1) % 2)
           	print "Decoded codeword: ", ''.join(code_orig)
           	print "Final Message: ", ''.join(code_orig[:k])
        elif z1 == 0 and z2 != 0:
       		print "Atleast 3 errors have occurred!"
       	elif z1 != 0 and z2 != z1^3:
        	print "Checking roots..."
        	beta = z2/(z1^3) + 1
        	print "beta: ", beta
        	sum = 0
        	for i in range(0, r):
        		sum += beta
        		beta *= beta
        	print "Trace: ", sum
        	if sum != 0:
        		print "No roots exists!"
        		print "Atleast 3 errors have occurred!"
        	else:
        		print "Two roots exists!"
        		pass
            # err_column_no = (np.where((H == prod).all(0))[1][0])
            # print("Error has occurred in the %s bit!" % str(err_column_no + 1))
            # code_orig[err_column_no] = str((int(code_orig[err_column_no]) + 1) % 2)
            # print("Decoded codeword: ", ''.join(code_orig))
            # print("Final Message: ", ''.join(code_orig[:k]))

    else:
        print("Invalid choice!")


