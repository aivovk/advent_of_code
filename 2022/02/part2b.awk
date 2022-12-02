BEGIN {for(;i<256;i++)ord[sprintf("%c",i)]=i}
{
    p1+=1+ord[$2]-ord["X"]+3*((ord[$2]-ord[$1]-1)%3)
    p2+=3*(ord[$2]-ord["X"])+1+((ord[$2]+ord[$1]-1)%3)
}
END {print p1 ; print p2}
