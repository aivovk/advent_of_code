def load():
    data = [int(n) for n in open('input.txt', 'r').read().split()]
    return sorted(data)

def partTwo(data):
    """
  
    """
    data = [0] + data # add starting location
    count = [0] * len(data) # number of ways of reaching that adapter
    count[0] = 1
    for i in range(1, len(data)):
        count[i] = count[i-1] # always reachable from previous

        # check if reachable from adapters 2 and 3 spots ago
        r2 =  (i > 1) and (4 > (data[i] - data[i-2]))
        r3 =  (i > 2) and (4 > (data[i] - data[i-3]))
        if r2:
            count[i] += count[i-2]
        if r3:
            count[i] += count[i-3]
    return count[-1]

def partOne(data):
    """
    
    """
    #diffs = data[1:] - data[:-1]
    c1 = int(data[0] == 1)
    c3 = 1 + int(data[0] == 3)
    for i in range(1, len(data)):
        c1 += (data[i] - data[i-1] == 1)
        c3 += (data[i] - data[i-1] == 3)
    return c1 * c3

if __name__=='__main__':
    data = load()
    print(partOne(data))
    print(partTwo(data))
