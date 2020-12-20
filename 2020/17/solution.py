import collections

def partOne():
    xyz = collections.defaultdict(bool)
    with open('input.txt', 'r') as f:
        z = 0
        y = 0
        for line in f:
            x = 0
            for c in line:
                xyz[(x,y,z)] = (c=='#')
                x += 1
            y += 1
    xlim = [0,x]
    ylim = [0,y]
    zlim = [0,1]

    for step in range(6):
        xlim[0] -= 1
        xlim[1] += 1
        ylim[0] -= 1
        ylim[1] += 1
        zlim[0] -= 1
        zlim[1] += 1
        nextstep = collections.defaultdict(bool)
        for x in range(*xlim):
            for y in range(*ylim):
                for z in range(*zlim):
                    neighbourCoordinates = [(x+ix, y+iy, z+iz)
                                            for ix in range(-1,2)
                                            for iy in range(-1,2)
                                            for iz in range(-1,2)
                                            if ix != 0 or iy != 0 or iz != 0]
                                            
                    activeNeighbours = sum(xyz[k] for k in neighbourCoordinates)

                    if xyz[(x,y,z)]:
                        if activeNeighbours == 2 or activeNeighbours == 3:
                            nextstep[(x,y,z)] = True
                    else:
                        if activeNeighbours == 3:
                            nextstep[(x,y,z)] = True
        xyz = nextstep
    return sum(value for value in xyz.values())

def partTwo():
    xyzw = collections.defaultdict(bool)
    with open('input.txt', 'r') as f:
        z = 0
        w = 0
        y = 0
        for line in f:
            x = 0
            for c in line:
                xyzw[(x,y,z,w)] = (c=='#')
                x += 1
            y += 1
    xlim = [0,x]
    ylim = [0,y]
    zlim = [0,1]
    wlim = [0,1]

    for step in range(6):
        xlim[0] -= 1
        xlim[1] += 1
        ylim[0] -= 1
        ylim[1] += 1
        zlim[0] -= 1
        zlim[1] += 1
        wlim[0] -= 1
        wlim[1] += 1
        nextstep = collections.defaultdict(bool)
        for x in range(*xlim):
            for y in range(*ylim):
                for z in range(*zlim):
                    for w in range(*wlim):
                        neighbourCoordinates = [(x+ix, y+iy, z+iz, w+iw)
                                                for ix in range(-1,2)
                                                for iy in range(-1,2)
                                                for iz in range(-1,2)
                                                for iw in range(-1,2)
                                                if ix != 0 or iy != 0 or iz != 0 or iw != 0]

                        activeNeighbours = sum(xyzw[k] for k in neighbourCoordinates)

                        if xyzw[(x,y,z,w)]:
                            if activeNeighbours == 2 or activeNeighbours == 3:
                                nextstep[(x,y,z,w)] = True
                        else:
                            if activeNeighbours == 3:
                                nextstep[(x,y,z,w)] = True
        xyzw = nextstep
    return sum(value for value in xyzw.values())

if __name__=="__main__":
    print(partOne())
    print(partTwo())
