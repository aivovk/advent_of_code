def doHomework(evaluateFunc):
    s = 0
    with open('input.txt', 'r') as f:
        for line in f:
            s += evaluateFunc(line.replace(' ','').replace('\n',''))
    return s

def partOne():
    return doHomework(evaluateInOrder)

def partTwo():
    return doHomework(evaluateAddFirst)
    
def findNextToken(expr):
    stack = 0
    for i, c in enumerate(expr):
        if c=='(':
            stack += 1
        elif c==')':
            stack -= 1
            
        if stack == 0:
            return i + 1

def evaluateAddFirst(expr):
    tokenOne = 0
    op = '+'
    while True:
        # addition the same as in order
        if op == '+':
            endNextToken = findNextToken(expr)
            if endNextToken > 1:
                tokenTwo = evaluateAddFirst(expr[1:endNextToken-1])
            else:
                tokenTwo = int(expr[0])
            tokenOne += tokenTwo
        # if multiplication, evaluate the rest of expression first
        else:
            endNextToken = len(expr)
            tokenOne *= evaluateAddFirst(expr[:endNextToken])

        if len(expr) > endNextToken:
            op = expr[endNextToken]
            expr = expr[endNextToken+1:]
        else:
            break


    return tokenOne
        
def evaluateInOrder(expr):
    tokenOne = 0
    op = '+'
    while True:
        endNextToken = findNextToken(expr)

        # all numbers are 1 digit long
        # strip parantheses if we don't have a number
        if endNextToken > 1:
            tokenTwo = evaluateInOrder(expr[1:endNextToken-1])
        else:
            tokenTwo = int(expr[0])
            
        if op == '+':
            tokenOne += tokenTwo
        else:
            tokenOne *= tokenTwo
            
        if len(expr) > endNextToken:
            op = expr[endNextToken]
            expr = expr[endNextToken+1:]
        else:
            break
        
    
    return tokenOne

if __name__=="__main__":
    print(partOne())
    print(partTwo())
