def partOne():
    differences = set()

    with open("input.txt") as f:
        for line in f:
            n = int(line)
            if n in differences:
                return n * (2020 - n)
            differences.add(2020 - n)

            
def partTwoBruteForce():
    with open("input.txt") as f:
        nums = [int(line) for line in f]
    nums.sort()

    # brute force for now
    for i1 in range(len(nums)):
        for i2 in range(i1 + 1, len(nums)):
            for i3 in range( i2 + 1, len(nums)):
                if nums[i1] + nums[i2] + nums[i3] == 2020:
                    return nums[i1]*nums[i2]*nums[i3]
def partTwo():
    with open("input.txt") as f:
        nums = [int(line) for line in f]
    nums.sort()
    setOfNums = set(nums)

    for i1 in range(len(nums)):
        for i2 in range(i1+1,len(nums)):
            n1 = nums[i1]
            n2 = nums[i2]            
            n3 = 2020 - nums[i1] - nums[i2]
            if n3 in setOfNums and n3 != n1 and n3 != n2:
                return n1 * n2 * n3

# all numbers are different
def checkFile():
    with open("input.txt") as f:
        nums = [int(line) for line in f]
    assert(len(nums) == len(set(nums)))

if __name__=="__main__":
    checkFile()
    print(partOne())
    print(partTwo())
