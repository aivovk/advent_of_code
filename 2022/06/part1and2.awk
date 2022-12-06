{ print find_unique_substr(4)"\n"find_unique_substr(14) }

function find_unique_substr(len,    char_counts, i, c){
    for ( i = 1 ; i <= length($0) ; i++){
	c = substr($0,i,1)
	char_counts[c]++;
	if (i > len){
	    c = substr($0, i - len, 1)
	    char_counts[c]--
	    if (char_counts[c] == 0) delete char_counts[c]
	}
	if (length(char_counts) == len) return i
    }
}

