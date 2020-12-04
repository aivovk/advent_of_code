import re

def filePlusBlankLine(filename):
    with open(filename, 'r') as f:
        for line in f:
            yield line
    yield '\n'

def partOneAndTwo():
    numValidKeys = 0
    numValidPassports = 0
    patterns = {'byr':'^19[2-9][0-9]|200[0-2]$',
                'iyr':'^201[0-9]|2020$',
                'eyr':'^202[0-9]|2030$',
                'hgt':'^1[5-8][0-9]cm|19[0-3]cm|59in|6[0-9]in|7[0-6]in$',
                'hcl':'^#[0-9a-f]{6}$',
                'ecl':'^amb|blu|brn|gry|grn|hzl|oth$',
                'pid':'^[\d]{9}$'}
    patterns = {key:re.compile(value) for key,value in patterns.items()}
    VALID_KEYS = set(patterns.keys())

    keys = set()
    validatedKeys = set()
   
    for line in filePlusBlankLine('input.txt'):
        line = line.rstrip('\n')
        if len(line) == 0:
            numValidKeys += (len(keys) == len(VALID_KEYS))
            numValidPassports += (len(validatedKeys) == len(VALID_KEYS))
            keys = set()
            validatedKeys = set()
        else:
            entries = line.split(' ')
            for entry in entries:
                key, value = entry.split(':')
                if key in VALID_KEYS:
                    keys.add(key)
                    if patterns[key].match(value):
                        validatedKeys.add(key)
        
    return numValidKeys, numValidPassports

if __name__=="__main__":
    partOne, partTwo = partOneAndTwo()
    print(partOne)
    print(partTwo)
