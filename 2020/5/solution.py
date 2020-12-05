def partOne():
    maxSeatID = 0
    minSeatID = 1000000
    sumSeatID = 0
    with open("input.txt") as f:
        for line in f:
            row = 0
            partition = 1
            for c in line[0:7][::-1]:
                row += (c=='B') * partition
                partition *= 2

            col = 0
            partition = 1
            for c in line[7:10][::-1]:
                col += (c=='R') * partition
                partition *=2
                
            seatID = row * 8 + col
            sumSeatID += seatID
            maxSeatID = max(maxSeatID, seatID)
            minSeatID = min(minSeatID, seatID)
    return minSeatID, maxSeatID, sumSeatID

def partTwo():
    minSeatID, maxSeatID, sumSeatID = partOne()
    n = maxSeatID - minSeatID + 1
    trueSumSeatID = minSeatID * n + int(n*(n-1)/2)
    missingSeatID = trueSumSeatID - sumSeatID
    return missingSeatID

if __name__=="__main__":
    print(partOne()[1])
    print(partTwo())
