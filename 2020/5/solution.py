def partOne():
    maxSeatID = 0
    minSeatID = 1000000
    sumSeatID = 0
    conversion = {'F':'0',
                  'B':'1',
                  'L':'0',
                  'R':'1'}
    with open("input.txt") as f:
        for line in f:
            seatID = int(''.join(conversion[c] for c in line[:10]),2)
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
