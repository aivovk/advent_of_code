import numpy as np
import math
import collections

def partOne():
    tiles, tileIDs = readTiles('input.txt')
    adj_tiles = findAdjacent(tiles)
    return math.prod(tileIDs[k] for k,v in adj_tiles.items() if len(v) == 2)

def getSeaMonsterMask():
    monstr = '                  # #    ##    ##    ### #  #  #  #  #  #   '
    monster = np.reshape(np.array(list(monstr)), (3, int(len(monstr)/3)))
    return monster == '#'

def readTiles(filename):
    # return a list of the tiles as 2D numpy arrays
    with open(filename, 'r') as f:
        lines = f.readlines()
        tile_strs = ''.join(lines).split('\n\n')
        tiles = [np.reshape(np.array(list(''.join(tile_str.split('\n')[1:11]))), (10,10)) for tile_str in tile_strs]
        tileIDs = [int(id_str[5:id_str.find(':')]) for id_str in tile_strs]
    return tiles, tileIDs

def findAdjacent(tiles):
    adj_tiles = collections.defaultdict(set)
    for i in range(len(tiles)):
        for j in range(i+1,len(tiles)):
            if len(adj_tiles[i]) < 4 and\
               len(adj_tiles[j]) < 4 and\
               match(tiles[i], tiles[j]) is not None:
                adj_tiles[j].add(i)
                adj_tiles[i].add(j)
    return adj_tiles

def match(tileA, tileB):
    # find which edge of A matches B
    for i in range(4):
        if (tileA[0] == tileB[0]).all()\
           or (tileA[0] == tileB[0,::-1]).all():
            return 0
        if (tileA[-1] == tileB[-1]).all()\
           or (tileA[-1] == tileB[-1,::-1]).all():
            return 2
        if (tileA[:,0] == tileB[:,0]).all()\
           or (tileA[:,0] == tileB[::-1,0]).all():
            return 1
        if (tileA[:,-1] == tileB[:,-1]).all()\
           or (tileA[:,-1] == tileB[::-1,-1]).all():
            return 3
        tileB = np.rot90(tileB)
    # return None

def getImage():
    '''
    assemble the tiles in the correct locations
    rotate and flip them to the correct orientation
    remove the edges and concatenate into 1 2D array
    '''
    tiles, tileIDs = readTiles('input.txt')
    adj_tiles = findAdjacent(tiles)
  
    size = int(len(tiles)**0.5)
    puzzle = [[0 for i in range(size)] for i in range(size)]

    starting_corner = [k for k, v in adj_tiles.items() if len(v)==2][0]

    puzzle[0][0] = starting_corner
    
    for row in range(size):
        for col in range(size):
            """
            always going left to right and top to bottom
            so match with row -1 and col -1
            """
            if row + col > 0:
                # to_match is the left and above pieces
                to_match = []
                if row > 0:
                    to_match.append(puzzle[row-1][col])
                if col > 0:
                    to_match.append(puzzle[row][col-1])

                # matches is the set of adjacent pieces shared by to_match
                matches = set(adj_tiles[to_match[0]])
                for m in to_match[1:]:
                    matches &= adj_tiles[m]

                # choosing the piece with the min adjacent tiles ensures
                # walls instead of sides are matched when necessary
                fits = 5
                best_piece = None
                for m in matches:
                    if len(adj_tiles[m]) < fits:
                        fits = len(adj_tiles[m])
                        best_piece = m
                assert(best_piece is not None)
                puzzle[row][col] = best_piece
                
                for m in to_match:
                    adj_tiles[m].remove(puzzle[row][col])
                    adj_tiles[puzzle[row][col]].remove(m)
    '''
    top 0
    left 1
    bottom 2
    right 3

    get orientations of 2 matching sides
    rotate until one side matches
    flip if necessary to match the other sides
    '''
    # everything except the bottom row and right col
    for row in range(size - 1):
        for col in range(size - 1):
            current = puzzle[row][col]
            right = match(tiles[current], tiles[puzzle[row][col+1]])
            bottom = match(tiles[current], tiles[puzzle[row+1][col]])

            while right%4 != 3:
                tiles[current] = np.rot90(tiles[current])
                right += 1
                bottom += 1
            if bottom%4 != 2: # flip vertically
                tiles[current] = np.flipud(tiles[current])
    # match bottom row
    for col in range(size - 1):
        current = puzzle[-1][col]
        right = match(tiles[current], tiles[puzzle[-1][col+1]])
        top = match(tiles[current], tiles[puzzle[-2][col]])
        while right%4 != 3:
            tiles[current] = np.rot90(tiles[current])
            right += 1
            top += 1
        if top%4 != 0: # flip vertically
            tiles[current] = np.flipud(tiles[current])
    # match right col
    for row in range(size - 1):
        current = puzzle[row][-1]
        left = match(tiles[current], tiles[puzzle[row][-2]])
        bottom = match(tiles[current], tiles[puzzle[row+1][-1]])
        while left%4 != 1:
            tiles[current] = np.rot90(tiles[current])
            left += 1
            bottom += 1
        if bottom%4 != 2: # flip vertically
            tiles[current] = np.flipud(tiles[current])
    # match bottom right corner
    current = puzzle[-1][-1]
    left = match(tiles[current], tiles[puzzle[-1][-2]])
    top = match(tiles[current], tiles[puzzle[-2][-1]])
    while left%4 != 1:
        tiles[current] = np.rot90(tiles[current])
        left += 1
        top += 1
    if top %4 != 0:
        tiles[current] = np.flipud(tiles[current])

    # cutoff edges and assemble the image
    seg_size = len(tiles[0]) - 2
    img_size = seg_size * size
    image = np.empty((img_size, img_size), dtype = tiles[0].dtype)
    for row in range(size):
        for col in range(size):
            image[row*seg_size:(row+1)*seg_size,
                  col*seg_size:(col+1)*seg_size] =\
            tiles[puzzle[row][col]][1:1+seg_size,1:1+seg_size]
    return image

def partTwo():
    num_monsters = 0
    img = getImage()
    monster_mask = getSeaMonsterMask()
    masks = [np.flipud(np.rot90(monster_mask,k=i)) for i in range(4)] +\
        [np.rot90(monster_mask,k=i) for i in range(4)]
    for mask in masks:
        h = mask.shape[0]
        w = mask.shape[1]
        for row in range(img.shape[0] - h):
            for col in range(img.shape[1] - w):
                if (img[row:row+h,col:col+w][mask] == '#').all():
                    num_monsters += 1
    # monsters can't overlap?
    return (img=='#').sum() - num_monsters * monster_mask.sum()
    
            
if __name__=="__main__":
    print(partOne())
    print(partTwo())
