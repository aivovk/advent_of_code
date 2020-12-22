import collections

def partOne():
    p1 = collections.deque()
    p2 = collections.deque()
    with open('input.txt', 'r') as f:
        mode = 'P1'
        for line in f:
            if line[0] == '\n':
                mode = 'P2'
            else:
                if line[0] != 'P':
                    if mode == 'P1':
                        p1.append(int(line))
                    else:
                        p2.append(int(line))
    while len(p1) != 0 and len(p2) != 0:
        c1 = p1.popleft()
        c2 = p2.popleft()
        if c1 > c2:
            p1.extend((c1,c2))
        else:
            p2.extend((c2,c1))
    if len(p1) == 0:
        p1 = p2
    
    return sum((len(p1)-i)*c for i,c in enumerate(p1))

def partTwo():
    p1 = collections.deque()
    p2 = collections.deque()
    with open('input.txt', 'r') as f:
        mode = 'P1'
        for line in f:
            if line[0] == '\n':
                mode = 'P2'
            else:
                if line[0] != 'P':
                    if mode == 'P1':
                        p1.append(int(line))
                    else:
                        p2.append(int(line))
    p1_won, winning_deck = recursive_combat(p1, p2)
    
    return sum((len(winning_deck)-i)*c for i,c in enumerate(winning_deck))

def recursive_combat(p1, p2):
    p1_perms = []
    p2_perms = []
    while True:
        if p1 in p1_perms and p2 in p2_perms:
            return True, p1
        
        p1_perms.append(p1.copy())
        p2_perms.append(p2.copy())

        if len(p1) == 0:
            return False, p2
        if len(p2) == 0:
            return True, p1
        
        c1 = p1.popleft()
        c2 = p2.popleft()
        if len(p1) < c1 or len(p2) < c2:
            p1_won = (c1 > c2)
        else:
            p1_won, junk = recursive_combat(collections.deque(p1[i] for i in range(c1)),
                                            collections.deque(p2[i] for i in range(c2)))
            
        if p1_won:
            p1.extend((c1,c2))
        else:
            p2.extend((c2,c1))

if __name__=="__main__":
    print(partOne())
    print(partTwo())
