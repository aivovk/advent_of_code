import numpy as np
import math

def partOne():
    s = 0
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

if __name__=="__main__":
    print(partOne())
