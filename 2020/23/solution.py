class Node:
    def __init__(self, val):
        self.val = val
        self.next_node = None
    def get_list(self, n=9):
        node = self
        cups = []
        while n>0:
            cups.append(node.val)
            node = node.next_node
            n -= 1
        return cups
    
def partOne(input_txt):
    cups = crabCups(input_txt,9,100)
    return ''.join([str(c) for c in cups[1:]])

def partTwo(input_txt):
    cups = crabCups(input_txt,10**6,10**7)
    return cups[1]*cups[2]
    
def crabCups(input_txt,num_cups,num_moves):
    # the index to cups is cup number - 1
    
    cups = [Node(int(i+1)) for i in range(num_cups)]

    # arrange cups based on input
    for i, c in enumerate(input_txt):
        cups[int(c)-1].next_node = cups[int(input_txt[(i+1)%len(input_txt)])-1]

    # rest of the cups are in order
    for i in range(len(input_txt)+1, num_cups):
        cups[i-1].next_node = cups[i]

    # link the start and end of the input cups to the in order cups
    if num_cups > len(input_txt):
        cups[int(input_txt[-1]) - 1].next_node = cups[len(input_txt)+1-1]
        cups[num_cups-1].next_node = cups[int(input_txt[0])-1]
    
    current = cups[int(input_txt[0])-1]
    
    for move in range(num_moves):
        removed = current.next_node
        removed_vals = [removed.val,
                        removed.next_node.val,
                        removed.next_node.next_node.val]
        current.next_node = removed.next_node.next_node.next_node

        # do
        dest = current.val - 1
        dest += (dest == 0) * len(cups)
        while dest in removed_vals:
            dest -= 1
            dest += (dest == 0) * len(cups)

        # insert the removed cups at dest
        after_dest = cups[dest-1].next_node
        cups[dest-1].next_node = removed
        removed.next_node.next_node.next_node = after_dest
            
        current = current.next_node

    return(cups[1-1].get_list())

if __name__=="__main__":
    print(partOne('389125467'))
    print(partTwo('389125467'))
