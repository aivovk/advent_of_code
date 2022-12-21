BEGIN {
    FS = "[ :]"
}
NF == 3 {
    nums[$1] = $3
    next
}
NF == 5 {
    ops[$1] = $4
    left[$1] = $3
    right[$1] = $5
}
END {
    print evaluate("root")
    if (contains_humn(left["root"])) print make_equal(left["root"], evaluate(right["root"]))
    else print make_equal(right["root"], evaluate(left["root"]))
}

function evaluate(monkey) {
    if (monkey in nums)
	return nums[monkey]
    if (ops[monkey] == "+")
	return evaluate(left[monkey]) + evaluate(right[monkey])
    if (ops[monkey] == "-")
	return evaluate(left[monkey]) - evaluate(right[monkey])
    if (ops[monkey] == "*")
	return evaluate(left[monkey]) * evaluate(right[monkey])
    if (ops[monkey] == "/")
	return evaluate(left[monkey]) / evaluate(right[monkey])
}

function make_equal(branch, result){
    if (branch == "humn") return result
    if (contains_humn(left[branch])) {
	right_result = evaluate(right[branch])
	if (ops[branch] == "+")
	    left_result = result - right_result
	if (ops[branch] == "-")
	    left_result = result + right_result
	if (ops[branch] == "*")
	    left_result = result / right_result
	if (ops[branch] == "/")
	    left_result = result * right_result
	return make_equal(left[branch], left_result)
    }
    else {
	left_result = evaluate(left[branch])
	if (ops[branch] == "+")
	    right_result = result - left_result
	if (ops[branch] == "-")
	    right_result = left_result - result
	if (ops[branch] == "*")
	    right_result = result / left_result
	if (ops[branch] == "/")
	    right_result = left_result / result
	return make_equal(right[branch], right_result)
    }
}

function contains_humn(tree) { # can memoize
    if (tree == "humn") return 1
    if (tree in nums) return 0
    return contains_humn(left[tree]) || contains_humn(right[tree])
}
