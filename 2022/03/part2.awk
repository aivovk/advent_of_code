BEGIN{ for(;i<256;i++)ord[sprintf("%c",i)]=i }
NR % 3 == 1 { one = $0 }
NR % 3 == 2 { two = $0 }
NR % 3 == 0 {
    gsub("[^"one"]","")
    gsub("[^"two"]","")
    c = substr($0,1,1)
    total += match(c, /[a-z]/) ? 1+ord[c]-ord["a"] : 27+ord[c]-ord["A"]
}
END{ print total }
