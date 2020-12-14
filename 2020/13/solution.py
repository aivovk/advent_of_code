def partOne():
    with open('input.txt', 'r') as f:
        lines = f.readlines()
    earliest = int(lines[0])
    busses = [int(s) for s in lines[1].split(',') if s != 'x']

    wait_times = [(int(earliest/bus) + 1) * bus - earliest for bus in busses]
    min_wait_time, i  = min((wait_time, i) for (i, wait_time) in enumerate(wait_times))
    
    return min_wait_time * busses[i]

def partTwo():
    with open('input.txt', 'r') as f:
        lines = f.readlines()

    # list of (bus ID, offset after timestamp)
    busses = [(int(s), i) for i, s in enumerate(lines[1].split(',')) if s != 'x']

    # for each bus look for busses that will arrive at the same time
    # (if their relative offsets are divisible by bus ID)
    #
    # then for that bus, it's timestamp+offset will be divisible by the product
    # of all the bus IDs that arrive at the same time (since they are relatively prime)
    factors = [1] * len(busses)
    for current in range(len(busses)):
        for other in range(len(busses)):
            if abs(busses[current][1] - busses[other][1]) % busses[other][0] == 0:
                factors[current] *= busses[other][0]

    # find and test multiples of the max factor
    i_max = factors.index(max(factors))

    max_factor = factors[i_max]
    offset_max = busses[i_max][1]
 
    # no need to check busses already in max_factor
    busses = [(bus, offset) for bus, offset in busses if max_factor % bus != 0]
 
    mult = 1
    while True:
        timestamp = max_factor * mult - offset_max
  
        i = 0
        while i < len(busses):
            # (timestamp + offset) % busID
            if (timestamp + busses[i][1]) % busses[i][0] != 0:
                break
            i += 1

        # all arrival times match
        if i == len(busses):
            break
        
        mult += 1
    return timestamp
    
if __name__=="__main__":
    print(partOne())
    print(partTwo())
