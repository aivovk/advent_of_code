def partOne():
    differences = set()

    with open("input.txt") as f:
        for line in f:
            n = int(line)
            if n in differences:
                return n * (2020 - n)
            differences.add(2020 - n)

            
def partTwo():
    with open("input.txt") as f:
        nums = [int(line) for line in f]

    nums.sort()

    # brute force for now
    for i1 in range(len(nums)):
        for i2 in range(i1 + 1, len(nums)):
            for i3 in range( i2 + 1, len(nums)):
                if nums[i1] + nums[i2] + nums[i3] == 2020:
                    return nums[i1]*nums[i2]*nums[i3]

print(partOne())
print(partTwo())
