#==========================
##  sigma test vector ##
#==========================
# with open("C:\\Users\\aharo\\Desktop\\sigma_test_vetor.txt","w") as file:
    # #0 xor 0 = 0
    # for i in range(128):
    #     file.write("0")
    # file.write(" ")
    # for i in range(128):
    #     file.write("0")
    # file.write(" ")
    # for i in range(128):
    #     file.write("0")
    # file.write("\n")
    # # 1 xor 1 = 0
    # for i in range(128):
    #     file.write("1")
    # file.write(" ")
    # for i in range(128):
    #     file.write("1")
    # file.write(" ")
    # for i in range(128):
    #     file.write("0")
    # file.write("\n")
    # # 10 xor 01 = 11
    # for i in range(128):
    #     if i%2 == 0:
    #         file.write("0")
    #     else:
    #         file.write("1")
    # file.write(" ")
    # for i in range(128):
    #     if i % 2 == 0:
    #         file.write("1")
    #     else:
    #         file.write("0")
    # file.write(" ")
    # for i in range(128):
    #     file.write("1")
    # file.write("\n")
    # # 01 xor 10 = 11
    # for i in range(128):
    #     if i%2 == 0:
    #         file.write("1")
    #     else:
    #         file.write("0")
    # file.write(" ")
    # for i in range(128):
    #     if i % 2 == 0:
    #         file.write("0")
    #     else:
    #         file.write("1")
    # file.write(" ")
    # for i in range(128):
    #     file.write("1")
    # file.write("\n")

#===========================================
####  test vector for tau (transpose)   ####
#===========================================
from galois_operations import G_mult as Gmult
def make_matrix(a):
     b = []
     for i in range(2):
         for j in range(0,len(a)-1,2):
             if j%2 == 0:
                 b = b + [f"{a[j]}{a[j+1]}"]
         a = [a[len(a)-1]] + a[:len(a)-1]
     return b

def transpose(matrix):
    t = []
    t.append(matrix[0])
    t.append(matrix[4])
    t.append(matrix[8])
    t.append(matrix[12])
    t.append(matrix[1])
    t.append(matrix[5])
    t.append(matrix[9])
    t.append(matrix[13])
    t.append(matrix[2])
    t.append(matrix[6])
    t.append(matrix[10])
    t.append(matrix[14])
    t.append(matrix[3])
    t.append(matrix[7])
    t.append(matrix[11])
    t.append(matrix[15])
    return t

def permutation(matrix):
    """ for pi function(permutation) test vector"""
    t = []
    t.append(matrix[0])
    t.append(matrix[5])
    t.append(matrix[10])
    t.append(matrix[15])
    t.append(matrix[4])
    t.append(matrix[9])
    t.append(matrix[14])
    t.append(matrix[3])
    t.append(matrix[8])
    t.append(matrix[13])
    t.append(matrix[2])
    t.append(matrix[7])
    t.append(matrix[12])
    t.append(matrix[1])
    t.append(matrix[6])
    t.append(matrix[11])
    return t

def key_extract(matrix):
    """ for omega function(key extract) test vector"""
    t = [0]*16
    primitive = 285
    t[0] = (int(matrix[0], 16) ^ int(matrix[4], 16) ^ int(matrix[8], 16) ^ int(matrix[12], 16))
    t[1] = (int(matrix[1], 16) ^ int(matrix[5], 16) ^ int(matrix[9], 16) ^ int(matrix[13], 16))
    t[2] = (int(matrix[2], 16) ^ int(matrix[6], 16) ^ int(matrix[10], 16) ^ int(matrix[14], 16))
    t[3] = (int(matrix[3], 16) ^ int(matrix[7], 16) ^ int(matrix[11], 16) ^ int(matrix[15], 16))
    t[4] = (int(matrix[0], 16) ^ Gmult(int(matrix[4], 16),2,primitive) ^ Gmult(int(matrix[8], 16),4,primitive) ^ Gmult(int(matrix[12], 16),8,primitive))
    t[5] = (int(matrix[1], 16) ^ Gmult(int(matrix[5], 16),2,primitive) ^ Gmult(int(matrix[9], 16),4,primitive) ^ Gmult(int(matrix[13], 16),8,primitive))
    t[6] = (int(matrix[2], 16) ^ Gmult(int(matrix[6], 16),2,primitive) ^ Gmult(int(matrix[10], 16),4,primitive) ^ Gmult(int(matrix[14], 16),8,primitive))
    t[7] = (int(matrix[3], 16) ^ Gmult(int(matrix[7], 16),2,primitive) ^ Gmult(int(matrix[11], 16),4,primitive) ^ Gmult(int(matrix[15], 16),8,primitive))
    t[8] = (int(matrix[0], 16) ^ Gmult(int(matrix[4], 16),6,primitive) ^ Gmult(int(matrix[8], 16),36,primitive) ^ Gmult(int(matrix[12], 16),216,primitive))
    t[9] = (int(matrix[1], 16) ^ Gmult(int(matrix[5], 16),6,primitive) ^ Gmult(int(matrix[9], 16),36,primitive) ^ Gmult(int(matrix[13], 16),216,primitive))
    t[10] = (int(matrix[2], 16) ^ Gmult(int(matrix[6], 16),6,primitive) ^ Gmult(int(matrix[10], 16),36,primitive) ^ Gmult(int(matrix[14], 16),216,primitive))
    t[11] = (int(matrix[3], 16) ^ Gmult(int(matrix[7], 16),6,primitive) ^ Gmult(int(matrix[11], 16),36,primitive) ^ Gmult(int(matrix[15], 16),216,primitive))
    t[12] = (int(matrix[0], 16) ^ Gmult(int(matrix[4], 16),8,primitive) ^ Gmult(int(matrix[8], 16),64,primitive) ^ Gmult(int(matrix[12], 16),512,primitive))
    t[13] = (int(matrix[1], 16) ^ Gmult(int(matrix[5], 16),8,primitive) ^ Gmult(int(matrix[9], 16),64,primitive) ^ Gmult(int(matrix[13], 16),512,primitive))
    t[14] = (int(matrix[2], 16) ^ Gmult(int(matrix[6], 16),8,primitive) ^ Gmult(int(matrix[10], 16),64,primitive) ^ Gmult(int(matrix[14], 16),512,primitive))
    t[15] = (int(matrix[3], 16) ^ Gmult(int(matrix[7], 16),8,primitive) ^ Gmult(int(matrix[11], 16),64,primitive) ^ Gmult(int(matrix[15], 16),512,primitive))

    for i in range(len(t)): #change the int to (string of)hexa
        t[i] = hex(t[i])[2:].zfill(2)
    return t

def diffusion(matrix):
    """ for theta function(diffusion) test vector"""
    t = [0]*16
    primitive = 285
    t[0] = (int(matrix[0], 16) ^ Gmult((int(matrix[1], 16) ^ int(matrix[3], 16)),2,primitive) ^ Gmult((int(matrix[2], 16) ^ int(matrix[3], 16)),4,primitive))
    t[1] = (int(matrix[1], 16) ^ Gmult((int(matrix[0], 16) ^ int(matrix[2], 16)),2,primitive) ^ Gmult((int(matrix[2], 16) ^ int(matrix[3], 16)),4,primitive))
    t[2] = (int(matrix[2], 16) ^ Gmult((int(matrix[1], 16) ^ int(matrix[3], 16)),2,primitive) ^ Gmult((int(matrix[0], 16) ^ int(matrix[1], 16)),4,primitive))
    t[3] = (int(matrix[3], 16) ^ Gmult((int(matrix[0], 16) ^ int(matrix[2], 16)),2,primitive) ^ Gmult((int(matrix[0], 16) ^ int(matrix[1], 16)),4,primitive))
    t[4] = (int(matrix[4], 16) ^ Gmult((int(matrix[5], 16) ^ int(matrix[7], 16)),2,primitive) ^ Gmult((int(matrix[6], 16) ^ int(matrix[7], 16)),4,primitive))
    t[5] = (int(matrix[5], 16) ^ Gmult((int(matrix[4], 16) ^ int(matrix[6], 16)),2,primitive) ^ Gmult((int(matrix[6], 16) ^ int(matrix[7], 16)),4,primitive))
    t[6] = (int(matrix[6], 16) ^ Gmult((int(matrix[5], 16) ^ int(matrix[7], 16)),2,primitive) ^ Gmult((int(matrix[4], 16) ^ int(matrix[5], 16)),4,primitive))
    t[7] = (int(matrix[7], 16) ^ Gmult((int(matrix[4], 16) ^ int(matrix[6], 16)),2,primitive) ^ Gmult((int(matrix[4], 16) ^ int(matrix[5], 16)),4,primitive))
    t[8] = (int(matrix[8], 16) ^ Gmult((int(matrix[9], 16) ^ int(matrix[11], 16)),2,primitive) ^ Gmult((int(matrix[10], 16) ^ int(matrix[11], 16)),4,primitive))
    t[9] = (int(matrix[9], 16) ^ Gmult((int(matrix[8], 16) ^ int(matrix[10], 16)),2,primitive) ^ Gmult((int(matrix[10], 16) ^ int(matrix[11], 16)),4,primitive))
    t[10] = (int(matrix[10], 16) ^ Gmult((int(matrix[9], 16) ^ int(matrix[11], 16)),2,primitive) ^ Gmult((int(matrix[8], 16) ^ int(matrix[9], 16)),4,primitive))
    t[11] = (int(matrix[11], 16) ^ Gmult((int(matrix[8], 16) ^ int(matrix[10], 16)),2,primitive) ^ Gmult((int(matrix[8], 16) ^ int(matrix[9], 16)),4,primitive))
    t[12] = (int(matrix[12], 16) ^ Gmult((int(matrix[13], 16) ^ int(matrix[15], 16)),2,primitive) ^ Gmult((int(matrix[14], 16) ^ int(matrix[15], 16)),4,primitive))
    t[13] = (int(matrix[13], 16) ^ Gmult((int(matrix[12], 16) ^ int(matrix[14], 16)),2,primitive) ^ Gmult((int(matrix[14], 16) ^ int(matrix[15], 16)),4,primitive))
    t[14] = (int(matrix[14], 16) ^ Gmult((int(matrix[13], 16) ^ int(matrix[15], 16)),2,primitive) ^ Gmult((int(matrix[12], 16) ^ int(matrix[13], 16)),4,primitive))
    t[15] = (int(matrix[15], 16) ^ Gmult((int(matrix[12], 16) ^ int(matrix[14], 16)),2,primitive) ^ Gmult((int(matrix[12], 16) ^ int(matrix[13], 16)),4,primitive))
    for i in range(len(t)): #change the int to (string of)hexa
        t[i] = hex(t[i]).replace("0x",'').zfill(2)
    return t


lst = ["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"]
with open("C:\\Users\\aharo\\Desktop\\theta_256_test_vetor.txt","w") as file:
    for i in range(16):
        mat = make_matrix(lst)
        lst = lst[1:] + [lst[0]]
        file.write(f"{''.join(mat)} {''.join(diffusion(mat))}\n")
        # change in the second argument the function name to create the wanted test vector


