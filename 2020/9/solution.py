def load():
    data = [int(n) for n in open('input.txt', 'r').read().split()]
    return data

def partTwo(data):
    """
    Find a contiguous list of n numbers (n>1) which sum to partOne
    
    return the sum of the max and min in this list
    """
    invalid = partOne(data)
    runningSum = 0 #big speedup
    for start in range(0,len(data) - 1):
        runningSum += data[start]
        for end in range(start+1,len(data)):
            runningSum += data[end]

            if runningSum > invalid: #small speedup
                break
            
            #assert(runningSum == sum(data[start:end+1]))
            if runningSum == invalid:
                return max(data[start:end+1]) + min(data[start:end+1])
        runningSum = 0
    raise "No range found"

def isTwoSum(data, iSum):
    """
    Can data[iSum] be expressed as the sum of two out of the 25 preceding numbers
    in data?
    """
    s = set()
    for i in range(iSum - 25, iSum):
        if data[iSum] - data[i] in s:
            return True
        s.add(data[i])
    return False

def partOne(data):
    """
    Find first number which can't be expressed as a sum out of the 25 previous
    """
    for i in range(25,len(data)):
        if not isTwoSum(data, i):
            return data[i]
    raise "All numbers valid"

if __name__=='__main__':
    data = load()
    print(partOne(data))
    print(partTwo(data))
