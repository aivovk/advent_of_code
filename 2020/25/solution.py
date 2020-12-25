def partOne(door_key=17807724, card_key=5764801):
    door_loop = getLoopSize(door_key)
    #card_loop = getLoopSize(card_key)
    #enc = genKey(1, card_loop, door_key)
    enc = genKey(1, door_loop, card_key)
    return enc

def getLoopSize(key):
    loop_size = 1
    k = genKey(1, loop_size)
    while k != key:
        loop_size += 1
        k = genKey(k, 1)
    return loop_size

def genKey(value, loop_size, num=7):
    for loop in range(loop_size):
        value *= num
        value %= 20201227
    return value

if __name__=="__main__":
    print(partOne())
    
