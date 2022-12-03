BEGIN{ for(;i<256;i++)ord[sprintf("%c",i)]=i }
{
    two = substr($1, length($1)/2+1)
    gsub("[^"two"]","")
    c = substr($1,1,1)
    total += match(c, /[a-z]/) ? 1+ord[c]-ord["a"] : 27+ord[c]-ord["A"]
}
END{ print total }
