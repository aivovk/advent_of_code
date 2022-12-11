BEGIN { FS = "[ ,:]+" } # strip commas and colons from fields
{ sub(/^[ \t]+/, "") } # trim leading whitespace
$1 == "Monkey" { i_monkey = $2 ; next } # Monkey: i
$1 == "Starting" { # Starting items: i, j, k, ...
    for(i = 3 ; i <= NF ; i++)
	items[i_monkey,i-2] = $i
    first_item[i_monkey] = 1
    n_items[i_monkey] = NF - 2
    next
}
$1 == "Operation" { # Operation: new = old [*+] (old|[0-9]+)
    operations[i_monkey] = $5
    right_operands[i_monkey] = $6
    next
}
$1 == "Test" { tests[i_monkey] = $4 ; next } # Test: divisible by i
$2 == "true" { true_throws[i_monkey] = $6 ; next } # If true: throw to monkey i
$2 == "false" { false_throws[i_monkey] = $6 ; next } # If false: throw to monkey j

END {
    cutoff = 1
    for (i in tests) cutoff *= tests[i]

    n_rounds = 10000
    n_monkeys = length(operations)
    for (i_round = 1 ; i_round <= n_rounds ; i_round++) {
	for (i_monkey = 0 ; i_monkey < n_monkeys ; i_monkey++) {
	    for (i_item = first_item[i_monkey] ; i_item <= n_items[i_monkey] ; i_item++) {
		item = items[i_monkey,i_item]
		item = operation(item, operations[i_monkey], right_operands[i_monkey])
		item = item % cutoff
		if (item % tests[i_monkey] == 0)
		    to_monkey = true_throws[i_monkey]
		else
		    to_monkey = false_throws[i_monkey]
		items[to_monkey,++n_items[to_monkey]] = item
		delete items[i_monkey,i_item] # optional
		inspections[i_monkey]++
	    }
	    first_item[i_monkey] = i_item
	}
    }
    output = ""
    for (i_monkey = 0 ; i_monkey < n_monkeys ; i_monkey++)
	output = output inspections[i_monkey] "\n"
    print output | "sort -n | tail -n 2 | awk '{p*=$1} END {print p}' p=1"
}

function operation(left, op, right) {
    if (right == "old") right = left
    if (op == "+") return right + left
    else if (op == "*") return right * left
    else print "ERROR: unexpected operation", left, op, right
    exit # unreachable
}
