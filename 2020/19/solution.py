import re

def partOneAndTwo():
    sumOne = 0
    sumTwo = 0
    mode = 'RULE'

    """
    the rules are either lists of lists or single characters
    the outer list represents the options (OR) (max of 2 options)
    the inner list represents rule composition
    e.g. 1 : 2 3 | 3 2
    is converted to key = 1, value = [[2,3],[3,2]]
    """
    rules = {}
    
    with open('input.txt', 'r') as f:
        for line in f:
            if line[0] == '\n': # end of the rules
                mode = 'MESSAGE'

                # can use the parser for Part One, but will need to copy the rules
                # (or read all the lines first and do Part One and Two separately)
                patternOne = re.compile(buildRuleZero(rules))
                
                rules[8] = [[42],[42,8]]
                rules[11] = [[42,31], [42,11,31]]
            else:
                if mode == 'RULE':
                    args = line.split(':')
                    number = int(args[0])
                    if args[1].find('"') != -1:
                        rules[number] = args[1][2]
                    else:
                        args = args[1].split('|')
                        assert(len(args)<3)
                        rules[number] = [[int(x) for x in arg.strip().split(' ')]
                                         for arg in args]
                if mode == 'MESSAGE':
                    line = line.rstrip('\n')
                    if patternOne.match(line) is not None:
                        sumOne += 1
                    if parse(rules, line, [0]):
                        sumTwo += 1
    return sumOne, sumTwo

def parse(rules, line, rule_stack):
    i = 0

    while len(rule_stack) > 0 and i < len(line):
        rule = rule_stack.pop()

        # terminal rule
        if type(rules[rule]) == str: 
            if line[i] == rules[rule]:
                i += 1
                if i == len(line) and len(rule_stack) == 0:
                    return True
            else:
                return False

        # non-terminal rule    
        else:
            if len(rules[rule]) == 1:
                rule_stack.extend(reversed(rules[rule][0]))
            else: # max two options
                return parse(rules, line[i:], rule_stack + list(reversed(rules[rule][0]))) \
                    or parse(rules, line[i:], rule_stack + list(reversed(rules[rule][1])))
    return False

def buildRuleZero(rules):
    pattern = '^'
    for rule in rules[0][0]:
        pattern += buildRule(rules, rule)
    pattern += '$'
    return pattern

def buildRule(rules, num):
    pattern = ''
    if len(rules[num]) > 1:
        pattern += '('
        
    # loop through OR patterns (options)
    for i, possibleRules in enumerate(rules[num]):
        for rule in possibleRules:
            if type(rule) == str:
                pattern += rule
            else:
                pattern += buildRule(rules, rule)
        if i != len(rules[num]) - 1:
            pattern += '|'
            
    if len(rules[num]) > 1:
        pattern += ')'    
    return pattern

if __name__=="__main__":
    print(partOneAndTwo())
