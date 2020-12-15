def partOneAndTwo(num_turns): 
    spoken = {}
    starting_numbers = [9,3,1,0,8,4]
    turn = 1
    for num in starting_numbers:
        spoken[num] = turn
        turn += 1
    last_spoken = starting_numbers[-1]
    while turn <= num_turns:
        if last_spoken not in spoken or spoken[last_spoken] == turn - 1:
            spoken[last_spoken] = turn - 1
            last_spoken = 0
        else:
            n = turn - 1 - spoken[last_spoken]
            spoken[last_spoken] = turn - 1
            last_spoken = n
        turn += 1
    
    return last_spoken

if __name__=="__main__":
    print(partOneAndTwo(2020))
    print(partOneAndTwo(30000000))
