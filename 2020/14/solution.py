def partOne():
    mem = {}
    with open('input.txt', 'r') as f:
        for line in f:
            if line[:4] == 'mask':
                mask = line[7:-1]
                mask1 = int(mask.replace('X','0'),2)
                mask2 = int(mask.replace('X','1'),2)
            elif line[:3] == 'mem':
                addr = int(line[4:].split(']')[0])
                value = int(line.split(' = ')[1])
                mem[addr] = (value | mask1) & mask2
    return sum(mem.values())

# toggle X values between 0 and 1 in all possible combinations
def genmasks(mask, masks):
    if 'X' not in mask:
        masks.append(int(''.join(mask),2))
        return
    
    i = mask.index('X')
    mask[i] = '0'
    genmasks(mask, masks)
    mask[i] = '1'
    genmasks(mask, masks)
    mask[i] = 'X'

def partTwo():
    mem = {}
    with open('input.txt', 'r') as f:
        for line in f:
            if line[:4] == 'mask':
                rawmask = line[7:-1]
                
                # first OR with the basemask
                # this will set all X locations and all 1 locations to 1, and leave
                # the 0 locations unchanged
                basemask = int(rawmask.replace('X','1'),2)

                # then AND with the Xmasks to toggle their values
                # (so set all other values to 1 in each Xmask)
                xmask = [c for c in rawmask.replace('0','1')]
                xmasks = []
                genmasks(xmask, xmasks)
                
            elif line[:3] == 'mem':
                addr = int(line[4:].split(']')[0])
                value = int(line.split(' = ')[1])
                for xmask in xmasks:
                    mem[(addr|basemask)&xmask] = value
    return sum(mem.values())

if __name__=="__main__":
    print(partOne())
    print(partTwo())
