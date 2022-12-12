BEGIN { FS = "[ ,:]+" } # strip commas and colons from fields
{ sub(/^[ \t]+/, "") } # trim leading whitespace
$1 == "Monkey" { monkey = $2 ; next } # Monkey: i
$1 == "Starting" { # Starting items: i, j, k, ...
    for(i = 3 ; i <= NF ; i++){
	items[++n_items] = $i
	start[n_items] = monkey
    }
    next
}
$1 == "Operation" { # Operation: new = old [*+] (old|[0-9]+)
    operations[monkey] = $5
    right_operands[monkey] = $6
    next
}
$1 == "Test" { tests[monkey] = $4 ; next } # Test: divisible by i
$2 == "true" { throws[monkey,1] = $6 ; next } # If true: throw to monkey i
$2 == "false" { throws[monkey,0] = $6 ; next } # If false: throw to monkey j

END {
    cutoff = 1
    for (i in tests) cutoff *= tests[i]

    n_rounds = 10000
    for (i_item = 1 ; i_item <= n_items ; i_item++){
	monkey = start[i_item]
	for (i_round = 1 ; i_round <= n_rounds ; i_round++) {
	    # every round pass the item at least once
	    # and once more for every time it is passed to a later monkey
	    do {
		inspections[monkey]++
		item = items[i_item]
		item = operation(item, operations[monkey], right_operands[monkey])
		item %= cutoff
		items[i_item] = item
		prev_monkey = monkey
		monkey = throws[monkey, item % tests[monkey] == 0]
	    } while (monkey > prev_monkey)
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
