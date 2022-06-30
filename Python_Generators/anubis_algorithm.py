"""
matrix = list of 16 number in hexadecimal, where each number represent one byte
"""
def Gmult(num1:int, num2:int, pri_polynom:int, power=False):
    if power == True:
        base = num1
        powerBy = num2
        for _ in range(powerBy-1):
            temp = 0
            for counter, i in enumerate(bin(num1)[2:]):
                if i == '1':
                    temp = temp ^ (base << len(bin(num1)[2:]) - (counter + 1))
            base = temp
        if len(bin(temp)) < len(bin(pri_polynom)):
            return temp
        elif len(bin(temp)) == len(bin(pri_polynom)):
            return (temp - 2 ** (len(bin(temp)) - 1)) ^ (pri_polynom - 2 ** (len(bin(pri_polynom)) - 1))
        else:
            while (len(bin(temp)) >= len(bin(pri_polynom))):
                temp = temp ^ (pri_polynom << (len(bin(temp)) - len(bin(pri_polynom))))
    else:
        temp = 0
        for counter,i in enumerate(bin(num2)[2:]):
            if i == '1':
                temp = temp^(num1<<len(bin(num2)[2:])-(counter+1))
        if len(bin(temp)) < len(bin(pri_polynom)):
            return temp
        elif len(bin(temp)) == len(bin(pri_polynom)):
            return (temp - 2**(len(bin(temp))-1))^(pri_polynom - 2**(len(bin(pri_polynom))-1))
        else:
            while(len(bin(temp)) >= len(bin(pri_polynom))):
                temp = temp^ (pri_polynom<<(len(bin(temp)) - len(bin(pri_polynom))))
    return temp

class anubis_functions:
    sbox = [0xa7, 0xd3, 0xe6, 0x71, 0xd0, 0xac, 0x4d, 0x79,
               0x3a, 0xc9, 0x91, 0xfc, 0x1e, 0x47, 0x54, 0xbd,
               0x8c, 0xa5, 0x7a, 0xfb, 0x63, 0xb8, 0xdd, 0xd4,
               0xe5, 0xb3, 0xc5, 0xbe, 0xa9, 0x88, 0x0c, 0xa2,
               0x39, 0xdf, 0x29, 0xda, 0x2b, 0xa8, 0xcb, 0x4c,
               0x4b, 0x22, 0xaa, 0x24, 0x41, 0x70, 0xa6, 0xf9,
               0x5a, 0xe2, 0xb0, 0x36, 0x7d, 0xe4, 0x33, 0xff,
               0x60, 0x20, 0x08, 0x8b, 0x5e, 0xab, 0x7f, 0x78,
               0x7c, 0x2c, 0x57, 0xd2, 0xdc, 0x6d, 0x7e, 0x0d,
               0x53, 0x94, 0xc3, 0x28, 0x27, 0x06, 0x5f, 0xad,
               0x67, 0x5c, 0x55, 0x48, 0x0e, 0x52, 0xea, 0x42,
               0x5b, 0x5d, 0x30, 0x58, 0x51, 0x59, 0x3c, 0x4e,
               0x38, 0x8a, 0x72, 0x14, 0xe7, 0xc6, 0xde, 0x50,
               0x8e, 0x92, 0xd1, 0x77, 0x93, 0x45, 0x9a, 0xce,
               0x2d, 0x03, 0x62, 0xb6, 0xb9, 0xbf, 0x96, 0x6b,
               0x3f, 0x07, 0x12, 0xae, 0x40, 0x34, 0x46, 0x3e,
               0xdb, 0xcf, 0xec, 0xcc, 0xc1, 0xa1, 0xc0, 0xd6,
               0x1d, 0xf4, 0x61, 0x3b, 0x10, 0xd8, 0x68, 0xa0,
               0xb1, 0x0a, 0x69, 0x6c, 0x49, 0xfa, 0x76, 0xc4,
               0x9e, 0x9b, 0x6e, 0x99, 0xc2, 0xb7, 0x98, 0xbc,
               0x8f, 0x85, 0x1f, 0xb4, 0xf8, 0x11, 0x2e, 0x00,
               0x25, 0x1c, 0x2a, 0x3d, 0x05, 0x4f, 0x7b, 0xb2,
               0x32, 0x90, 0xaf, 0x19, 0xa3, 0xf7, 0x73, 0x9d,
               0x15, 0x74, 0xee, 0xca, 0x9f, 0x0f, 0x1b, 0x75,
               0x86, 0x84, 0x9c, 0x4a, 0x97, 0x1a, 0x65, 0xf6,
               0xed, 0x09, 0xbb, 0x26, 0x83, 0xeb, 0x6f, 0x81,
               0x04, 0x6a, 0x43, 0x01, 0x17, 0xe1, 0x87, 0xf5,
               0x8d, 0xe3, 0x23, 0x80, 0x44, 0x16, 0x66, 0x21,
               0xfe, 0xd5, 0x31, 0xd9, 0x35, 0x18, 0x02, 0x64,
               0xf2, 0xf1, 0x56, 0xcd, 0x82, 0xc8, 0xba, 0xf0,
               0xef, 0xe9, 0xe8, 0xfd, 0x89, 0xd7, 0xc7, 0xb5,
               0xa4, 0x2f, 0x95, 0x13, 0x0b, 0xf3, 0xe0, 0x37]  # list of strings

    @classmethod
    def gamma(cls,vector: list) -> list:
        a = []
        for i in vector:
            a.append(hex(cls.sbox[int(i, 16)]).replace("0x", '').zfill(2))
        return a

    @classmethod
    def tau(cls,matrix: list)->list:
        """
        for the tau function in ANUBIS algorithm
        :param matrix: 4x4 matrix
        :return: the transpose matrix of the input
        """
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

    @classmethod
    def pi(cls,matrix: list)->list:
        """
        for pi function(permutation) in ANUBIS algorithm
        :param matrix: matrix of 16 parameters
        :return: permutated matrix by the ANUBIS permutation
        """
        t = []
        t.append(matrix[0])
        t.append(matrix[13])
        t.append(matrix[10])
        t.append(matrix[7])
        t.append(matrix[4])
        t.append(matrix[1])
        t.append(matrix[14])
        t.append(matrix[11])
        t.append(matrix[8])
        t.append(matrix[5])
        t.append(matrix[2])
        t.append(matrix[15])
        t.append(matrix[12])
        t.append(matrix[9])
        t.append(matrix[6])
        t.append(matrix[3])
        return t

    @classmethod
    def omega(cls,matrix:list)->list:
        """
        for omega function(key extract) test vector
        :param matrix: matrix of 16 parameters
        :return: 4x4 matrix of extracted key
        """
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
        t[8] = (int(matrix[0], 16) ^ Gmult(int(matrix[4], 16),6,primitive) ^ Gmult(int(matrix[8], 16),20,primitive) ^ Gmult(int(matrix[12], 16),120,primitive))
        t[9] = (int(matrix[1], 16) ^ Gmult(int(matrix[5], 16),6,primitive) ^ Gmult(int(matrix[9], 16),20,primitive) ^ Gmult(int(matrix[13], 16),120,primitive))
        t[10] = (int(matrix[2], 16) ^ Gmult(int(matrix[6], 16),6,primitive) ^ Gmult(int(matrix[10], 16),20,primitive) ^ Gmult(int(matrix[14], 16),120,primitive))
        t[11] = (int(matrix[3], 16) ^ Gmult(int(matrix[7], 16),6,primitive) ^ Gmult(int(matrix[11], 16),20,primitive) ^ Gmult(int(matrix[15], 16),120,primitive))
        t[12] = (int(matrix[0], 16) ^ Gmult(int(matrix[4], 16),8,primitive) ^ Gmult(int(matrix[8], 16),64,primitive) ^ Gmult(int(matrix[12], 16),58,primitive))
        t[13] = (int(matrix[1], 16) ^ Gmult(int(matrix[5], 16),8,primitive) ^ Gmult(int(matrix[9], 16),64,primitive) ^ Gmult(int(matrix[13], 16),58,primitive))
        t[14] = (int(matrix[2], 16) ^ Gmult(int(matrix[6], 16),8,primitive) ^ Gmult(int(matrix[10], 16),64,primitive) ^ Gmult(int(matrix[14], 16),58,primitive))
        t[15] = (int(matrix[3], 16) ^ Gmult(int(matrix[7], 16),8,primitive) ^ Gmult(int(matrix[11], 16),64,primitive) ^ Gmult(int(matrix[15], 16),58,primitive))

        for i in range(len(t)): #change the int to (string of)hexa
            t[i] = hex(t[i])[2:].zfill(2)
        return t

    @classmethod
    def theta(cls,matrix:list)->list:
        """
        for theta function(diffusion) test vector
        :param matrix: matrix of 16 parameters
        :return: diffused matrix in ANUBIS method
        """
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

    @classmethod
    def sigma(cls,num1:list,num2:list)->list:
        result = []
        if len(num1) != len(num2):
            assert False, "please enter 2 numbers in the same length"
        else:
            for i in range(len(num1)):
                xored_param = int(num1[i], 16) ^ int(num2[i], 16)
                result.append(hex(xored_param).replace("0x", '').zfill(2))
        return result

    @classmethod
    def key_evolution(cls, key: list, round_constant: list) -> list:
        """
        first part of the key schedule
        :param key: key for encryption
        :param round_constant: for algorithm purpose
        :return: round key for every round
        """
        ## gamma ##
        key_list = anubis_functions.gamma(key)
        ## pi ##
        after_pi = anubis_functions.pi(key_list)
        ## theta ##
        after_theta = anubis_functions.theta(after_pi)
        ## sigma ##
        evolutioned_key = anubis_functions.sigma(after_theta, round_constant)
        return evolutioned_key

    @classmethod
    def key_selection(cls, evolutioned_key: list) -> list:
        """
        the second part of the key schedule
        :param evolutioned_key: the results of the key evolution
        :return: the key schedule for the round
        """
        ## gamma ##
        key_list = anubis_functions.gamma(evolutioned_key)
        ## omega ##
        after_omega = anubis_functions.omega(key_list)
        ## tau ##
        round_key = anubis_functions.tau(after_omega)
        return round_key

    @classmethod
    def round_function(cls, plain_text: list, round_key: list, round_number: int) -> str:
        """
        round of the ANUBIS algorithm
        :param round_number:
        :param plain_text: text to crypt,
        :param round_key: the key to encrypt with for this round
        :return: cipher text of this round of encrypting
        """
        ## gamma ##
        text_list = anubis_functions.gamma(plain_text)
        ## tau ##
        after_tau = anubis_functions.tau(text_list)
        ## theta ##
        after_theta = anubis_functions.theta(after_tau) if round_number != 12 else after_tau
        ## sigma ##
        cipher = anubis_functions.sigma(after_theta,round_key)
        return cipher

def turnToHex(matrix):
    result = []
    for i in matrix:
        t = hex(i)
        result.append(t)
    return result


class MyMatrix:
    def __init__(self,numbers: list, size: int):
        """
        we will create a matrix form a list on strings, when each string represent a
        hexadecimal number between 0 to 256 (one byte)
        :param size:
        :param numbers: list of numbers to create matrix from them
               size: size of the matrix (anubis can use different sizes for keys)
        :return: matrix = list of 16 number in hexadecimal, where each number represent one byte
        """
        self.numbers = numbers
        self.size = size
        if type(numbers) != list:
            assert False, "please enter a list to make a matrix"
        if len(numbers) != self.size:
            assert False, "please enter a matching list and list size"

def anubis_function(key:list, plain_text:list,encrypt = True)->list:
    round_con1 = ["a7", "d3", "e6", "71", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
    round_con2 = ["d0", "ac", "4d", "79", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
    round_con3 = ["3a", "c9", "91", "fc", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
    round_con4 = ["1e", "47", "54", "bd", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
    round_con5 = ["8c", "a5", "7a", "fb", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
    round_con6 = ["63", "b8", "dd", "d4", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
    round_con7 = ["e5", "b3", "c5", "be", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
    round_con8 = ["a9", "88", "0c", "a2", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
    round_con9 = ["39", "df", "29", "da", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
    round_con10 = ["2b", "a8", "cb", "4c", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
    round_con11 = ["4b", "22", "aa", "24", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
    round_con12 = ["41", "70", "a6", "f9", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00", "00"]
    constant_list = [round_con1, round_con2, round_con3, round_con4, round_con5, round_con6, round_con7, round_con8,
                     round_con9, round_con10, round_con11, round_con12]
    evolutioned_key = [key]
    selected_key = [anubis_functions.key_selection(key)]
    rounds_out = []
    key2use = key
    #plain2use = anubis_functions.sigma(plain_text, selected_key[0])
    for i in range(12):
        # print(f"\nkey evolution round {i+1}:\n===================\n")
        #print(f"key: {key2use}")
        evolutioned_key.append(anubis_functions.key_evolution(key2use,constant_list[i]))
        key2use = evolutioned_key[len(evolutioned_key)-1]
    for i in range(12):
        #print(f"\nkey_selection round {i + 1}:\n===================\n")
        #print(f"evo key: {evolutioned_key[i+1]}")
        selected_key.append(anubis_functions.key_selection(evolutioned_key[i+1]))
    if encrypt:
        plain2use = anubis_functions.sigma(anubis_functions.key_selection(key), plain_text)
    else:
        plain2use = anubis_functions.sigma(plain_text, selected_key[12])
    print(f"evolutioned key 0: {evolutioned_key[12]}")
    print(f"selected key 0: {selected_key[12]}")
    print(f"{len(evolutioned_key)} , {len(selected_key)}")
    print(f"round in: {plain2use}")
    for i in range(12):
        if encrypt:
            rounds_out.append(anubis_functions.round_function(plain2use,selected_key[i+1],i+1))
        elif i == 11:
            rounds_out.append(anubis_functions.round_function(plain2use, selected_key[0], i + 1))
        else:
            rounds_out.append(anubis_functions.round_function(plain2use, anubis_functions.theta(selected_key[11-i]), i + 1))
        plain2use = rounds_out[len(rounds_out)-1]
    cipher = rounds_out[11]
    return cipher



plain = ["00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00"]
plain2 = ["D7","4C","1B","10","C7","D8","91","F4","B4","59","1B","2C","DB","93","99","10"]
key = ["00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00"]
plain1 = ["11","11","11","11","11","11","11","11","11","11","11","11","11","11","11","11"]
key1 = ["11","11","11","11","11","11","11","11","11","11","11","11","11","11","11","11"]
expected_zeros = ["62","5F","0F","66","3B","F0","0F","2D","67","B1","E8","B0","4F","67","A4","84"]

a = ['76', '3f', '2e', '1f', 'a3', '25', '1d', '7c', '2d', 'c1', '03', 'bc', '11', '4c', '5c', 'ae']
b = ['f7', '7f', '6f', '83', '73', '3a', 'e3', '7e', '0e', 'c0', 'eb', '18', '06', '9b', '10', 'bd']


print(anubis_function(key,plain))

def make_matrix(a):
    b = []
    for i in range(2):
        #print("a matrix is:")
        #print(a, len(a))
        for j in range(0, len(a) - 1, 2):
            if j % 2 == 0:
                #print(j)
                b = b + [f"{a[j]}{a[j + 1]}"]
        a = [a[len(a) - 1]] + a[:len(a) - 1]
    return b

