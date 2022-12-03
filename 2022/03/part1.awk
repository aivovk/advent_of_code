BEGIN{ for(;i<256;i++)ord[sprintf("%c",i)]=i }
{
    len = length($1)
    two = substr($1, len/2+1)
    $1 = substr($1, 1, len/2)
    gsub("[^"two"]","")
    c = substr($1,1,1)
    total += match(c, /[a-z]/) ? 1+ord[c]-ord["a"] : 27+ord[c]-ord["A"]
}
END{ print total }
