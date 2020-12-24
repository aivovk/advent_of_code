import collections

dirs = {'e' : (1,0),
        'se' : (1,1),
        'sw' : (0,1),
        'w' : (-1,0),
        'nw' : (-1,-1),
        'ne' : (0,-1)}

def partOne():
    tiles = collections.defaultdict(bool)
    with open('input.txt', 'r') as f:
        for line in f:
            line = line.rstrip('\n')
            locx = 0
            locy = 0
            i = 0
            while i < len(line):
                if line[i] in dirs.keys():
                    d = dirs[line[i]]
                    i += 1
                else:
                    d = dirs[line[i:i+2]]
                    i += 2
                locx += d[0]
                locy += d[1]
            tiles[(locx,locy)] = not tiles[(locx, locy)]
    return sum(1 for k,v in tiles.items() if v), tiles

def countNeighbours(tiles, x, y):
    n = 0
    for k,v in dirs.items():
        n += tiles[(x+v[0],y+v[1])]
    return n

def partTwo(tiles):
    minx = min(x for x,y in tiles.keys())
    maxx = max(x for x,y in tiles.keys())
    miny = min(y for x,y in tiles.keys())
    maxy = max(y for x,y in tiles.keys())

    for step in range(100):
        minx -= 1
        miny -= 1
        maxx += 1
        maxy += 1
        nextstep = collections.defaultdict(bool)
        for x in range(minx, maxx+1):
            for y in range(miny, maxy+1):
                n = countNeighbours(tiles, x, y)
                if tiles[(x,y)]: # black
                    if n == 1 or n == 2:
                        nextstep[(x,y)] = True
                elif n == 2: # white
                    nextstep[(x,y)] = True
        tiles = nextstep
    return sum(1 for k,v in tiles.items() if v)

if __name__=="__main__":
    day0, tiles = partOne()
    print(day0)
    print(partTwo(tiles))
