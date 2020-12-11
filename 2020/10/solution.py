def load():
    data = [int(n) for n in open('input.txt', 'r').read().split()]
    return sorted(data)

def partTwo(data):
    data = [0,0,0] + data # add buffer (0,1) and starting location (2)
    count = [0] * len(data) # number of ways of reaching that adapter
    count[2] = 1
    for i in range(3, len(data)):
        count[i] = count[i-1] # always reachable from previous

        # check if reachable from adapters 2 and 3 spots ago
        if data[i] - data[i-2] <= 3:
            count[i] += count[i-2]
            if data[i] - data[i-3] <= 3:
                count[i] += count[i-3]
    return count[-1]

def partOne(data):
    #diffs = [*map(int.__sub__, data[1:], data[:-1])]
    #return (1+diffs.count(1))*(1+diffs.count(3))
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
