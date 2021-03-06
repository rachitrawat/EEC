"""
Implementation of 2-error-correcting [n = 2r − 1, k = n − 2r, d ≥ 5] BCH Codes in Sage.
Given a parameter r, the program generates a Generator and a Parity Check matrix. For any
message as an input while encoding, the program outputs a codeword. And for any codeword as
an input for decoding, it returns the decoded codeword and the final message.
"""

r = int(input("Enter r: "))
n = pow(2,r)-1
k = n-2*r
d = 5

print("n:{} k:{} d:{} r:{}".format(n, k, d, r))

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

for i in range(0,k):
	z=0
	for j in range(i,n):
		G[i][j]=gx.list()[z]
		z+=1
		if z == len(gx.list()):
			break

print("\nG: ")
print(G)

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


# returns mod 2 matrix
def mod_2(matrix):
    for idx, val in enumerate(matrix):
        for idx2, val2 in enumerate(val):
            matrix[idx][idx2] %= 2

    return matrix

def trace_beta(beta):
	sum = 0
	for i in range(0, r):
		sum += beta
		beta *= beta
	return sum

def getFinalMsg(k, G, code_orig):
	msg = [int(G[:,0][0] * int(code_orig[0]))]
	for i in range(1,k):
		sum = 0
		for idx, element in enumerate(G[:,i]):
			if element == 1 and idx != i:
				sum += msg[idx]
		msg.append(int((sum + int(code_orig[i]))%2))
	return ''.join([str(x) for x in msg])

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

        print "Encoded message: ", ''.join([str(int(x)) for x in prod.tolist()[0]])

    elif ch == 2:
        code = list(raw_input("\nEnter %s bit code: " % n))
        code_orig = code
        msg_bits = getFinalMsg(k,G,code_orig)

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
           	print "Final Message: ", getFinalMsg(k,G,code_orig)
        elif z1 == 0 and z2 != 0:
       		print "Atleast 3 errors have occurred!"
       	elif z1 != 0 and z2 != z1^3:
        	print "Checking roots..."
        	beta = z2/(z1^3) + 1
        	print "beta: ", beta
        	sum = trace_beta(beta)
        	print "Trace: ", sum
        	if sum != 0:
        		print "No roots exists!"
        		print "Atleast 3 errors have occurred!"
        	else:
				print "Two roots exists!"
				NB = []
				gen = 0
				for i in range(1, 2 ^ r):
					if trace_beta(a ^ i) != 0:
						gen = (a ^ i)
						break

				for i in range(0, r):
					NB.append(gen)
					gen *= gen

				print "Normal Basis: ", NB

				nb_arr=[]
				for element in NB:
					x=element.polynomial().list()
					while True:
						if len(x) < r:
							x.append(0)
						else:
							break
					nb_arr.append(x)

				M = matrix(nb_arr)
				M = ~M

				b_arr = matrix(beta.polynomial().list())

				M=M.numpy()
				B=b_arr.numpy()

				tmp = B[0].tolist()
				while True:
					if len(tmp) < r:
						tmp.append(0)
					else:
						break

				B = np.array(tmp)

				prod = B.dot(M)

				s = [0]
				for i in range(1, r):
					s.append((s[i-1] + prod[i]) % 2)


				Y = 0

				for i in range(0,r):
					if s[i] != 0:
						Y += NB[i]

				r1 = z1 * Y
				r2 = z1 + r1

				print "i: ", r1
				print "j: ", r2

				pos1 = H[0].index(r1)
				pos2 = H[0].index(r2)
				print "2 errors have occurred at positions {} {}".format(pos1+1, pos2+1)
				code_orig[pos1] = str((int(code_orig[pos1]) + 1) % 2)
				code_orig[pos2] = str((int(code_orig[pos2]) + 1) % 2)
				print "Decoded codeword: ", ''.join(code_orig)
				print "Final Message: ", getFinalMsg(k,G,code_orig)

    else:
        print("Invalid choice!")


