import re

def partOneAndTwo():
    validOne = 0
    validTwo = 0
    fmt = "(\d+)-(\d+) (\w): (\w+)"
    pattern = re.compile(fmt)
    
    with open("input.txt") as f:
        for line in f:
            args = pattern.match(line)
            low = int(args.group(1))
            high = int(args.group(2))
            letter = args.group(3)
            password = args.group(4)
            
            n = password.count(letter)
            if low <= n <= high:
                validOne += 1
            if (password[low-1] == letter)  != (password[high-1] == letter):
                validTwo += 1
    return validOne, validTwo

if __name__=="__main__":
    print(partOneAndTwo())
