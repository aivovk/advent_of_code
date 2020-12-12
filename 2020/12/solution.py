def partOne():
    x = 0
    y = 0
    dirs = [[1,0], [0,1],[-1,0],[0,-1]]
    idir = 0
    with open('input.txt', 'r') as f:
        for line in f:
            instruction = line[0]
            number = int(line[1:-1])
            if instruction == 'N':
                y += number
            elif instruction == 'S':
                y -= number
            elif instruction == 'E':
                x += number
            elif instruction == 'W':
                x -= number
            elif instruction == 'L':
                idir += int(number/90)
            elif instruction == 'R':
                idir -= int(number/90)
            elif instruction == 'F':
                d = dirs[idir % len(dirs)]
                x += d[0] * number
                y += d[1] * number
    return abs(x) + abs(y)

def partTwo():
    x = 0
    y = 0
    wx = 10
    wy = 1
    with open('input.txt', 'r') as f:
        for line in f:
            instruction = line[0]
            number = int(line[1:-1])
            if instruction == 'N':
                wy += number
            elif instruction == 'S':
                wy -= number
            elif instruction == 'E':
                wx += number
            elif instruction == 'W':
                wx -= number
            elif instruction == 'L':
                while number > 0:
                    wx, wy = -wy, wx
                    number -= 90
            elif instruction == 'R':
                while number > 0:
                    wx, wy = wy, -wx
                    number -= 90
            elif instruction == 'F':
                x += wx * number
                y += wy * number
    return abs(x) + abs(y)

if __name__=="__main__":
    print(partOne())
    print(partTwo())
