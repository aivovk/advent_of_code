BEGIN { FS = "[ ,:]+" } # strip commas and colons from fields
{ sub(/^[ \t]+/, "") } # trim leading whitespace
$1 == "Monkey" { i_monkey = $2 ; next } # Monkey: i
$1 == "Starting" { # Starting items: i, j, k, ...
    for(i = 3 ; i <= NF ; i++){
	items[++n_items] = $i
	owner[n_items] = i_monkey
    }
    next
}
$1 == "Operation" { # Operation: new = old [*+] (old|[0-9]+)
    operations[i_monkey] = $5
    right_operands[i_monkey] = $6
    next
}
$1 == "Test" { tests[i_monkey] = $4 ; next } # Test: divisible by i
$2 == "true" { throws[i_monkey,1] = $6 ; next } # If true: throw to monkey i
$2 == "false" { throws[i_monkey,0] = $6 ; next } # If false: throw to monkey j

END {
    cutoff = 1
    for (i in tests) cutoff *= tests[i]

    n_rounds = 10000
    n_monkeys = length(operations)
    for (i_round = 1 ; i_round <= n_rounds ; i_round++) {
	for (i_monkey = 0 ; i_monkey < n_monkeys ; i_monkey++) {
	    for (i_item = 1 ; i_item <= n_items ; i_item++) {
		if (owner[i_item] == i_monkey) {
		    item = items[i_item]
		    item = operation(item, operations[i_monkey], right_operands[i_monkey])
		    item = item % cutoff
		    to_monkey = throws[i_monkey, item % tests[i_monkey] == 0]
		    items[i_item] = item
		    owner[i_item] = to_monkey
		    inspections[i_monkey]++
		}
	    }
	}
    }
    asort(inspections, inspections, "@val_num_desc")
    print inspections[1] * inspections[2]
}

function operation(left, op, right) {
    if (right == "old") right = left
    if (op == "+") return right + left
    else if (op == "*") return right * left
}
