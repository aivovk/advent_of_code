# need bc and qalc (libqalculate)
BEGIN { FS = "[ :]+" }
NF == 2 { nums[$1] = $2 ;  next }
NF == 4 { left[$1] = $2 ; ops[$1] = $3 ; right[$1] = $4 }
END {
    print build("root") | "bc"
    nums["humn"] = "x"
    ops["root"] = "="
    print build("root") | "xargs qalc -t | awk '{print $3}'"
}

function build(monkey) {
    if (monkey in nums)	return nums[monkey]
    else return "(" build(left[monkey]) ops[monkey] build(right[monkey]) ")"
}
