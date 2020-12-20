import math

def partOneAndTwo():
    with open('input.txt', 'r') as f:
        MODE = ['FIELD', 'YOUR_TICKET', 'NEARBY_TICKET']
        mode = 0 #
        fields = []
        sumInvalidValues = 0
        for line in f:
            if line == '\n':
                mode += 1
            elif MODE[mode] == 'FIELD':
                fields.append([])
                ranges = line.split(': ')[1]
                fields[-1] = [(int(r.split('-')[0]),
                               int(r.split('-')[1])) for r in ranges.split(' or ')]
                
            elif MODE[mode] == 'YOUR_TICKET':
                if line[0] != 'y':
                    myTicket = [int(v) for v in line.split(',')]

                    #initialize all fields to possible
                    entryIndexToPossibleFields = [set(range(len(fields)))
                                                  for i in range(len(myTicket))]
                    
            elif MODE[mode] == 'NEARBY_TICKET':
                if line[0] != 'n':
                    nums = line.split(',')
                    for i in range(len(nums)):
                        num = int(nums[i])
                        possibleFields = getPossibleFields(fields, num)
                        if len(possibleFields) == 0:
                            sumInvalidValues += num
                        else:
                            entryIndexToPossibleFields[i] &= possibleFields 
                            
    # find unique mapping from entry to field
    for i in range(len(entryIndexToPossibleFields)):
        for j in range(len(entryIndexToPossibleFields)):
            if len(entryIndexToPossibleFields[i]) < len(entryIndexToPossibleFields[j]):
                entryIndexToPossibleFields[j] -= entryIndexToPossibleFields[i]

    fieldNameToIndex = {}
    for i in range(len(entryIndexToPossibleFields)):
        fieldNameToIndex[entryIndexToPossibleFields[i].pop()] = i
       
    # the first 6 rules start with departure
    return sumInvalidValues, math.prod(myTicket[fieldNameToIndex[i]] for i in range(6))

def getPossibleFields(fields, num):
    possibleFields = set()
    for i,field in enumerate(fields):
        for r in field:
            if num >= r[0] and num <= r[1]:
                possibleFields.add(i)
    return possibleFields
  
if __name__=="__main__":
    print(partOneAndTwo())
