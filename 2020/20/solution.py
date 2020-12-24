import numpy as np
import math
import collections

def partOne():
    with open('input.txt', 'r') as f:
        lines = f.readlines()
        tile_strs = ''.join(lines).split('\n\n')
        tiles = [np.reshape(np.array(list(''.join(tile_str.split('\n')[1:11]))), (10,10)) for tile_str in tile_strs]
        tileIDs = [int(id_str[5:id_str.find(':')]) for id_str in tile_strs]
    print(tiles)
    edgeMatches = [0] * len(tiles)
    for i in range(len(tiles)):
        for j in range(i+1,len(tiles)):
            if edgeMatches[i] < 4 and edgeMatches[j] < 4 and edgesMatch(tiles[i], tiles[j]):
                edgeMatches[i] += 1
                edgeMatches[j] += 1
    return math.prod(tileIDs[i] for i, n in enumerate(edgeMatches) if n == 2)


def edgesMatch(tileA, tileB):
    for i in range(4):
        if (tileA[0] == tileB[0]).all()\
           or (tileA[0] == tileB[0,::-1]).all()\
           or (tileA[-1] == tileB[-1]).all()\
           or (tileA[-1] == tileB[-1,::-1]).all()\
           or (tileA[:,0] == tileB[:,0]).all()\
           or (tileA[:,0] == tileB[::-1,0]).all()\
           or (tileA[:,-1] == tileB[:,-1]).all()\
           or (tileA[:,-1] == tileB[::-1,-1]).all():
            return True
        tileB = np.rot90(tileB)
    
    return False

def readTiles(filename):
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
            if len(adj_tiles[i]) < 4 and len(adj_tiles[j]) < 4 and edgesMatch(tiles[i], tiles[j]):
                adj_tiles[j].add(i)
                adj_tiles[i].add(j)
    return adj_tiles

# find which edge of A matches B
def match(tileA, tileB):
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


if __name__=="__main__":
    #print(partOne())
    tiles, tileIDs = readTiles('input2.txt')
    adj_tiles = findAdjacent(tiles)
  
    size = int(len(tiles)**0.5)
    puzzle = [[0 for i in range(size)] for i in range(size)]

    starting_corner = [k for k, v in adj_tiles.items() if len(v)==2][0]

    puzzle[0][0] = starting_corner
    
    for row in range(size):
        for col in range(size):
            """
            always going left to right and top to bottom
            so we need to match with row -1 and col -1
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

                # choosing the piece with the min adjacent tiles ensures we
                # match walls instead of sides when we need to
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
    for row in range(size):
        for col in range(size):
            print(tiles[puzzle[row][col]])
    '''
    top 0
    left 1
    bottom 2
    right 3

    get the matches

    depending on that, we know whether to flip or not
    '''
    
    for row in range(size - 1):
        for col in range(size - 1):
            current = puzzle[row][col]
            right = match(tiles[current], tiles[puzzle[row+1][col]])
            bottom = match(tiles[current], tiles[puzzle[row][col+1]])
            while right%4 != 3:
                tiles[current] = np.rot90(tiles[current])
                right += 1
                bottom += 1
            #if bottom%4 != 2: # flip vertically
            #    tiles[current] = np.flipud(tiles[current])

    for rPuzzle in range(size):
        for row in range(len(tiles[0])):
            r = ''
            for cPuzzle in range(size):
                r+=' '
                for col in range(len(tiles[0])):
                    r += tiles[puzzle[rPuzzle][cPuzzle]][row,col]
            print(r)
        print('')
