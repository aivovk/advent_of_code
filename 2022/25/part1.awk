BEGIN {
    FS = ""
    d[2] = 2 ; d[1] = 1 ; d["-"] = -1 ; d["="] = -2
    s[0] = 0 ; s[1] = 1 ; s[2] = 2 ; s[3] = "=" ; s[4] = "-"
}
{
    p = 1
    for(i = NF ; i > 0 ; i--){
	n += p * d[$i]
        p *= 5
    }
}
END {
    while (n > 0){
	n += carry
        digit = n % 5
        snafu = s[digit] snafu
	carry = digit > 2
	n = (n - (n%5)) / 5
    }
    print snafu
}
