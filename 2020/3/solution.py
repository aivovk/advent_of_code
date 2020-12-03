def partOne(down=1, right= 3):
    numTrees = 0
    x = 0
    y = 0
    with open("input.txt") as f:
        for line in f:
            if y % down == 0:
                line = line.rstrip('\n')
                numTrees += (line[x % len(line)] == '#')
                x += right
            y += 1
    return numTrees

def partTwo():
    # reading the file too many times...
    return partOne(1,1) * partOne(1,3) * partOne(1,5) * partOne(1,7) * partOne(2,1)

if __name__=="__main__":
    print(partOne())
    print(partTwo())
