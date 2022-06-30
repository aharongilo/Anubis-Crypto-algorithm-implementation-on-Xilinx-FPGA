
def G_add(num1:int ,num2:int):
    return num1^num2

def G_mult(num1:int ,num2:int, pri_polynom:int):
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
        #temp_deg = len(bin(temp)[2:]) #degree of the multiply result so far
        #pri_deg = len(bin(pri_polynom)[2:]) #degree of the primitive polynom

if __name__ == "__main__":
    list = [2,4,6,8,36,216,64,512]
    for num in list:
        with open (f"C:\\Users\\aharo\\Desktop\\galois_mult\\mult_by_{num}.coe","w") as file:
            for i in range(0,256):
                #print(f"i = {hex(i)[2:].zfill(2)}, i*4 = {hex(G_mult(i,4,285))[2:].zfill(2)}")
                file.write(hex(G_mult(i,num,285))[2:].zfill(2))
                file.write("\n")