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


with open("C:\\users\\yosef\\Desktop\\trygmult2.txt","w") as file:
    for i in range(256):
        (
            file.write(f"{i}<={Gmult(i,2,285)};\n")
        )
'''
with open("C:\\Users\\aharo\\Desktop\\gamma_test_vector.txt","w") as file:
    for i in range(256):
        temp = hex(i)[2:].zfill(2)
        temp_r = hex(results[i])[2:].zfill(2) # from the string "0xaa" we take only "aa"
        print(f"{temp}  {temp_r}")
        ## for sbox: ##
        #file.write(f"\t\t8'h{temp}: out = 8'h{temp_r};\n")
        ## for sbox test vector ##
        #file.write(f"{temp.zfill(2)} {temp_r.zfill(2)}\n")
        ## for gamma test vector ##
        #file.write(f"{mygen(temp,16)} {mygen(temp_r,16)}\n")
        for a in mygen(temp,16):
            file.write(f"{a}")
        file.write(" ")
        for a in mygen(temp_r,16):
            file.write(f"{a}")
        file.write("\n")
        
plain = ["00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00"]
plain2 = ["D7","4C","1B","10","C7","D8","91","F4","B4","59","1B","2C","DB","93","99","10"]
key = ["00","00","00","00","00","00","00","00","00","00","00","00","00","00","00","00"]
plain1 = ["11","11","11","11","11","11","11","11","11","11","11","11","11","11","11","11"]
key1 = ["11","11","11","11","11","11","11","11","11","11","11","11","11","11","11","11"]
expected_zeros = ["62","5F","0F","66","3B","F0","0F","2D","67","B1","E8","B0","4F","67","A4","84"]

a = ['76', '3f', '2e', '1f', 'a3', '25', '1d', '7c', '2d', 'c1', '03', 'bc', '11', '4c', '5c', 'ae']
b = ['f7', '7f', '6f', '83', '73', '3a', 'e3', '7e', '0e', 'c0', 'eb', '18', '06', '9b', '10', 'bd']


print(anubis_function(key,plain))'''
Gmult();
