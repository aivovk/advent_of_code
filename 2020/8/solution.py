def branch(boot_code, pc, acc, executed, corrected):        
    if pc == len(boot_code):
        return acc
    if pc in executed or pc > len(boot_code) or pc < 0:
        return -1
    executed.add(pc)

    b2 = -1
    op, arg,  = boot_code[pc].split(' ')
    if op == 'acc':
        b1 = branch(boot_code, pc + 1, acc + int(arg), executed, corrected)
    else:
        nop = (op == 'nop')
        jmp = (op == 'jmp')
        b1 = branch(boot_code, pc + nop + jmp * int(arg), acc, executed, corrected)
        if not corrected:
            b2 = branch(boot_code, pc+ (not nop) + (not jmp)*int(arg), acc, executed, True)
        
    executed.remove(pc)
    return max(b1, b2)

def load():
    f = open('input.txt', 'r')
    boot_code = f.readlines()
    f.close()
    return boot_code

def partTwo(boot_code):
    return branch(boot_code, 0, 0, set(), False)

def partOne(boot_code):
    executed = set()
    pc = 0
    acc = 0
    while pc not in executed:
        executed.add(pc)
        op, arg,  = boot_code[pc].split(' ')
        nop = (op=='nop')
        jmp = (op=='jmp')
        acc += int(arg) * (not nop) * (not jmp)
        pc += (not jmp) + (jmp) * int(arg)
       
    return acc

if __name__=='__main__':
    boot_code = load()
    print(partOne(boot_code))
    print(partTwo(boot_code))
