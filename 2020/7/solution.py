import re
import collections

def buildTrees():
    pattern = re.compile("^(\d+) ([a-z\s]+) bag[s]?$")
    parents = collections.defaultdict(set)
    children = collections.defaultdict(list)
    with open("input.txt", 'r') as f:
        for line in f:
            line = line.rstrip('.\n')
            parent, children_str = line.split(" bags contain ")
            child_list = children_str.split(", ")
            for child_str in child_list:
                args = pattern.match(child_str)
                if args is not None:
                    numbags = int(args.group(1))
                    child = args.group(2)
                    parents[child].add(parent)
                    children[parent].append((child, numbags))
    return parents, children

def partOne(parents):
    search_set = parents['shiny gold']
    contains_set = set()
    
    while len(search_set) != 0:
        contains_set.update(search_set)
        next_search_set = set()
        for parent in search_set:
            next_search_set.update(parents[parent])
        search_set = next_search_set
    return len(contains_set)

def partTwo(children):
    return count_bags(children, 'shiny gold')

def count_bags(children, bag):
    total = 0
    for child in children[bag]:
        total += child[1] * (1 + count_bags(children, child[0]))
    return total

if __name__=="__main__":
    parents, children = buildTrees()
    print(partOne(parents))
    print(partTwo(children))
