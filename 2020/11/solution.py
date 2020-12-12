import numpy as np

def load():
    # pad the grid with floor all around, to skip edge checking
    with open('input.txt', 'r') as f:
        data = [['.'] + list(line) + ['.'] for line in f.read().split()]
    data = [['.']*len(data[0])] + data + [['.']*len(data[0])]
    data = np.array(data)
    
    return data

def updateOne(data, nextstep):
    modified = False
    for i in range(1,len(data)-1):
        for j in range(1,len(data[i])-1):
            if data[i,j] == 'L':
                if (data[i-1:i+2,j-1:j+2]=='#').sum() == 0:
                    nextstep[i,j] = '#'
                    modified = True
                else:
                    nextstep[i,j] = 'L'
            elif data[i,j] == '#':
                # -1 since we counted the current seat
                if (data[i-1:i+2,j-1:j+2]=='#').sum() - 1 >= 4:
                    nextstep[i,j] = 'L'
                    modified = True
                else:
                    nextstep[i,j] = '#'
    return modified

def isVisibleOccupiedSeatInDirection(data,i,j,d):
    nrows = data.shape[0]
    ncols = data.shape[1]
    row = i + d[0]
    col = j + d[1]
    while row > 0 and row < nrows - 1 and col > 0 and col < ncols - 1 and data[row,col] != 'L':
        if data[row,col] == '#':
            return True
        row += d[0]
        col += d[1]
    return False
        

def countVisibleOccupiedSeats(data,i,j):
    directions = [[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1],[0,-1],[1,-1]]
    return sum(isVisibleOccupiedSeatInDirection(data,i,j,d) for d in directions)

def updateTwo(data, nextstep):
    modified = False
    for i in range(1,len(data)-1):
        for j in range(1,len(data[i])-1):
            if data[i,j] == 'L':
                if countVisibleOccupiedSeats(data,i,j) == 0:
                    nextstep[i,j] = '#'
                    modified = True
                else:
                    nextstep[i,j] = 'L'
            elif data[i,j] == '#':
                if countVisibleOccupiedSeats(data,i,j) >= 5:
                    nextstep[i,j] = 'L'
                    modified = True
                else:
                    nextstep[i,j] = '#'
    return modified

def findSteadyState(data, updateRule):
    nextstep = np.copy(data)
    while updateRule(data, nextstep):
        data, nextstep = nextstep, data
    return (data == '#').sum()
    

if __name__=='__main__':
    print(findSteadyState(load(), updateOne))
    print(findSteadyState(load(), updateTwo))
