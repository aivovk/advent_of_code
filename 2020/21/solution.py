import collections

def partOneAndTwo():
    a_to_i = {} # map from allergens to possible ingredients
    ingredient_counts = collections.defaultdict(int)
    with open('input.txt', 'r') as f:
        for line in f:
            args = line.split(' (')
            ingredients = set(args[0].split(' '))
            
            for ingredient in ingredients:
                ingredient_counts[ingredient] += 1
            
            allergens = [arg[:-1] # strip , or )
                         for arg in args[1].rstrip('\n').split(' ')[1:]]
            
            for allergen in allergens:
                if allergen not in a_to_i:
                    a_to_i[allergen] = set(ingredients)
                else:
                    a_to_i[allergen] &= ingredients

    # find one-to-one allergen to ingredient map
    # (not the best way to do this)
    while sum(len(v) for v in a_to_i.values()) > len(a_to_i):
        for a1 in a_to_i:
            if len(a_to_i[a1]) == 1:
                for a2 in a_to_i:
                    if a1 != a2:
                        a_to_i[a2] -= a_to_i[a1]
                        
    # count number of times non-allergenic ingredients appear    
    allergenic_ingredients = set()
    for v in a_to_i.values():
        allergenic_ingredients |= v
    part_one = sum(v for k,v in ingredient_counts.items()
               if k not in allergenic_ingredients)

    # ingredients sorted by their allergen
    sorted_allergens = sorted(a_to_i.keys())
    part_two = ','.join([a_to_i[a].pop() for a in sorted_allergens])
    
    return part_one, part_two

if __name__=="__main__":
    print(partOneAndTwo())
