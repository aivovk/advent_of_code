import string

def filePlusBlankLine(filename):
    with open(filename, 'r') as f:
        for line in f:
            yield line
    yield '\n'

def partOneAndTwo():
    totalUnion = 0
    totalIntersection = 0
    union = set()
    intersection = set(string.ascii_lowercase)
    
    for line in filePlusBlankLine('input.txt'):
        line = line.rstrip('\n')
        if len(line) == 0:
            totalUnion += len(union)
            totalIntersection += len(intersection)
            union = set()
            intersection = set(string.ascii_lowercase)
        else:
            union |= set(line)
            intersection &= set(line)    
            
    return totalUnion, totalIntersection

if __name__=="__main__":
    print(partOneAndTwo())
